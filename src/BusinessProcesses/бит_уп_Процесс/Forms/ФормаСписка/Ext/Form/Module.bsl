
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ТабДокАлгоритм.Видимость   = Ложь;
	Элементы.ГрафическаяСхема.Видимость = Истина;
 
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.ФормаКомандаВидимостьАлгоритма.Пометка = ВидимостьАлгоритма;	
	УстановитьВидимостьАлгоритма(ВидимостьАлгоритма);
	
	Элементы.ФормаКомандаЗавершенные.Пометка = ЭтотОбъект.Завершенные;	
	УстановитьОтбор();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события "ОбработкаРасшифровки" поля табличного документа "ТабДокАлгоритм".
// 
&НаКлиенте
Процедура ТабДокАлгоритмОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		
		Если ЗначениеЗаполнено(Расшифровка.Задача) Тогда
			
			Оповещение = Новый ОписаниеОповещения("ЗакрытиеЗадачиОповещение", ЭтотОбъект);			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Ключ",Расшифровка.Задача);
			ОткрытьФорму("Задача.бит_уп_Задача.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект,,,,Оповещение, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
			
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

// Процедура - обработчик оповещения о закрытии формы задачи. 
// 
&НаКлиенте
Процедура ЗакрытиеЗадачиОповещение(Результат, ДополнительныеПараметры)  Экспорт
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;				
	ДействияПриЗакрытииФормыЗадачи(ТекущаяСтрока);
	
КонецПроцедуры // ОткрытиеФормыЗадачиОповещение()

// Процедура - обработчик события "ПриАктивизацииСтроки" табличного поля "Список".
// 
&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если ВидимостьАлгоритма Тогда
		
		ОтключитьОбработчикОжидания("ОжиданиеАктивизацииСтроки");
		ПодключитьОбработчикОжидания("ОжиданиеАктивизацииСтроки",0.1, Истина);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафическаяСхемаВыбор(Элемент)
	
	Если ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли; 
	
	Если Элементы.ГрафическаяСхема.ТекущийЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	КодТочки = Элементы.ГрафическаяСхема.ТекущийЭлемент.Имя;
	СтрокаТаблицыТочек = Неопределено;
	
	// Выполняем сканирование, что бы избежать серверного вызова при поиске в таблице.
	Для каждого СтрокаТаблицы Из ТаблицаТочкиВизы Цикл
		Если СтрокаТаблицы.КодТочки = КодТочки Тогда
			СтрокаТаблицыТочек = СтрокаТаблицы;
			Прервать;		
		КонецЕсли;
	КонецЦикла; 
	
	Если СтрокаТаблицыТочек = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ (СтрокаТаблицыТочек.ВидТочки = ПредопределенноеЗначение("Перечисление.бит_уп_ВидыТочекАлгоритмов.Действие")
		ИЛИ СтрокаТаблицыТочек.ВидТочки = ПредопределенноеЗначение("Перечисление.бит_уп_ВидыТочекАлгоритмов.ПодчиненныйПроцесс"))Тогда
		Возврат;	 
	КонецЕсли;

	Если ЗначениеЗаполнено(СтрокаТаблицыТочек.Задача) Тогда
		Оповещение = Новый ОписаниеОповещения("ЗакрытиеЗадачиОповещение", ЭтотОбъект);
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", СтрокаТаблицыТочек.Задача);
		ОткрытьФорму("Задача.бит_уп_Задача.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект,,,,Оповещение, 
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - действие команды "КомандаОткрытьИсториюИзменения".
// 
&НаКлиенте
Процедура КомандаОткрытьИсториюИзменения(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	
	Если НЕ ТекущаяСтрока = Неопределено Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Задача", ТекущаяСтрока.Ссылка);
		ОткрытьФорму("РегистрСведений.бит_ИсторияИзмененияСтатусовОбъектов.Форма.ФормаИсторияСостоянийЗадач",ПараметрыФормы, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - действие команды "КомандаВидимостьАлгоритма".
// 
&НаКлиенте
Процедура КомандаВидимостьАлгоритма(Команда)
	
	Элементы.ФормаКомандаВидимостьАлгоритма.Пометка = НЕ Элементы.ФормаКомандаВидимостьАлгоритма.Пометка;
	ВидимостьАлгоритма = Элементы.ФормаКомандаВидимостьАлгоритма.Пометка;
	
	УстановитьВидимостьАлгоритма(ВидимостьАлгоритма);
	
КонецПроцедуры

// Процедура - действие команды "КомандаОстановить".
// 
&НаКлиенте
Процедура КомандаОстановить(Команда)
	
	МассивВыделенных = Элементы.Список.ВыделенныеСтроки;
	флВыполнено = ОстановитьВозобновитьПроцесс(МассивВыделенных, "Остановить");
	
	Если флВыполнено Тогда
		
		ОповеститьОбИзменении(Тип("БизнесПроцессСсылка.бит_уп_Процесс"));
		ОповеститьОбИзменении(Тип("ЗадачаСсылка.бит_уп_Задача"));
		
	КонецЕсли; 
	
КонецПроцедуры

// Процедура - действие команды "КомандаПродолжить".
// 
&НаКлиенте
Процедура КомандаПродолжить(Команда)
	
	МассивВыделенных = Элементы.Список.ВыделенныеСтроки;
	флВыполнено = ОстановитьВозобновитьПроцесс(МассивВыделенных, "Возобновить");
	
	Если флВыполнено Тогда
		
		ОповеститьОбИзменении(Тип("БизнесПроцессСсылка.бит_уп_Процесс"));
		ОповеститьОбИзменении(Тип("ЗадачаСсылка.бит_уп_Задача"));		
		
	КонецЕсли; 
	
КонецПроцедуры

// Процедура - действие команды "КомандаОбновить".
// 
&НаКлиенте
Процедура КомандаОбновить(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;	
	Если НЕ ТекущаяСтрока = Неопределено Тогда
	
		СтрПар = Новый Структура("Алгоритм, Ссылка", ТекущаяСтрока.Алгоритм, ТекущаяСтрока.Ссылка);
		
	Иначе
		
		СтрПар = Неопределено;
	
	КонецЕсли; 
	
	ОбновитьВсе(СтрПар);
	
КонецПроцедуры

// Процедура - действие команды "СтатусПроцесса".
// 
&НаКлиенте
Процедура КомандаОтчетСтатусПроцесса(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	
	Если НЕ ТекущаяСтрока = Неопределено Тогда
	
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Процесс", ТекущаяСтрока.Ссылка);
		ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
		
		ФормаОтчета = ПолучитьФорму("Отчет.бит_ОтчетСтатусПроцесса.Форма", ПараметрыФормы, ЭтотОбъект);
		
		Если ФормаОтчета.Открыта() Тогда
			
			ФормаОтчета.СформироватьОтчет(ТекущаяСтрока.Ссылка);
			ФормаОтчета.Активизировать();
			
		Иначе
			
			ФормаОтчета.Открыть();
		
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПерезапустить(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	
	Если НЕ ТекущаяСтрока = Неопределено Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Процесс", ТекущаяСтрока.Ссылка);
		ПараметрыФормы.Вставить("Действие", "ПерезапускПроцесса");
		
		ОткрытьФорму("БизнесПроцесс.бит_уп_Процесс.ФормаОбъекта",ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗавершенные(Команда)
	
  Завершенные = НЕ Завершенные;
  Элементы.ФормаКомандаЗавершенные.Пометка = Завершенные;
  УстановитьОтбор();	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбзорСхемы(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;	

	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура; 
	ПараметрыФормы.Вставить("ГрафическаяСхема", ГрафическаяСхема);
	
	ОткрытьФорму("Справочник.бит_уп_Алгоритмы.Форма.ОбзорСхемы", ПараметрыФормы, 
		ЭтотОбъект, ТекущаяСтрока.Ссылка);
		
КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура - обработчик ожидания активизации строки списка. 
// 
&НаКлиенте
Процедура ОжиданиеАктивизацииСтроки()

	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;	

	Если НЕ ТекущаяСтрока = Неопределено Тогда

	   ДействияПриАктивизацииСтроки(ТекущаяСтрока.Алгоритм, ТекущаяСтрока.Ссылка);

	КонецЕсли; 
  
КонецПроцедуры // ОжиданиеАктивизацииСтроки() 

// Процедура устанавливает отбор списка.
// 
&НаКлиенте
Процедура УстановитьОтбор()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Завершен", Завершенные, 
		ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Завершенные)); 
	
КонецПроцедуры

// Процедура устанавливает видимость табличного поля со схемой алгоритма.
// 
// Параметры:
//  ВидимостьАлгоритма - Булево
// 
&НаКлиенте
Процедура УстановитьВидимостьАлгоритма(ВидимостьАлгоритма)
	
	# Если НЕ ВебКлиент Тогда
		Элементы.ГруппаАлгоритм.Видимость = ВидимостьАлгоритма;
	# КонецЕсли
	
	# Если ВебКлиент Тогда
		Элементы.ГруппаАлгоритм.Видимость = Ложь;
	# КонецЕсли
	
КонецПроцедуры // УстановитьВидимостьАлгоритма()

// Процедура выполняет на сервере действия, необходимые при активизации строки списка. 
// 
// Параметры:
//  Алгоритм - СправочникСсылка.бит_уп_Алгоритмы.
//  Процесс  - БизнесПроцессСсылка.бит_уп_Процесс.
// 
&НаСервере
Процедура ДействияПриАктивизацииСтроки(Алгоритм, Процесс, СохранятьНастройку=Ложь)

	Если ВидимостьАлгоритма Тогда
		
		Если НЕ ЗначениеЗаполнено(Алгоритм) Тогда
			ТабДокАлгоритм.Очистить();
			ГрафическаяСхема = Новый ГрафическаяСхема;
		Иначе
			
			Если СохранятьНастройку Тогда
				ХранилищеОбщихНастроек.Сохранить(Метаданные.БизнесПроцессы.бит_уп_Процесс.ПолноеИмя() 
					,"ПоказыватьСрокиИсполненияЗадач" 
					,ПоказыватьСрокиИсполненияЗадач);
			Иначе
				ПоказыватьСрокиИсполненияЗадач = ХранилищеОбщихНастроек.Загрузить(Метаданные.БизнесПроцессы.бит_уп_Процесс.ПолноеИмя() 
					,"ПоказыватьСрокиИсполненияЗадач");
			КонецЕсли; 
			
			ТочкиИЗадачи = Неопределено;
			бит_уп_Сервер.НарисоватьАлгоритмПроцесса(ТабДокАлгоритм, Алгоритм, Процесс, ПоказыватьСрокиИсполненияЗадач, ТочкиИЗадачи);
			ТаблицаТочкиВизы.Загрузить(ТочкиИЗадачи);
			
			// Версия схемы = 2
			РеквизитыАлгоритма = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Алгоритм, 
			"ВерсияСхемы, КартаМаршрута");
			
			Если РеквизитыАлгоритма.ВерсияСхемы = 2 Тогда
				ГрафическаяСхема = РеквизитыАлгоритма.КартаМаршрута.Получить();
				Для каждого СтрокаТаблицы Из ТаблицаТочкиВизы Цикл
					Если СтрокаТаблицы.ВидТочки = Перечисления.бит_уп_ВидыТочекАлгоритмов.Действие
						ИЛИ СтрокаТаблицы.ВидТочки = Перечисления.бит_уп_ВидыТочекАлгоритмов.ПодчиненныйПроцесс Тогда
						ВыделитьЭлементСхемы(СтрокаТаблицы);
						ПоказатьСрокиИсполненияЗадач(СтрокаТаблицы);
					КонецЕсли;
				КонецЦикла; 
			КонецЕсли; 
			
			Элементы.ТабДокАлгоритм.Видимость   = НЕ РеквизитыАлгоритма.ВерсияСхемы = 2;
			Элементы.ГрафическаяСхема.Видимость = РеквизитыАлгоритма.ВерсияСхемы = 2;
		КонецЕсли;
	КонецЕсли; 

КонецПроцедуры // ДействияПриАктивизацииСтроки()

&НаСервере
Процедура ВыделитьЭлементСхемы(ПараметрыТочки)
	
	Активные = Новый Массив(); 
	Активные.Добавить(Справочники.бит_СтатусыОбъектов.Задача_Создана);
	Активные.Добавить(Справочники.бит_СтатусыОбъектов.Задача_Просрочена);
	Активные.Добавить(Справочники.бит_СтатусыОбъектов.Задача_Принята);
	
	Выполненные = Новый Массив(); 
	Выполненные.Добавить(Справочники.бит_СтатусыОбъектов.Задача_Выполнена);
	Выполненные.Добавить(Справочники.бит_СтатусыОбъектов.Задача_Отменена);
	
	Ожидание = Новый Массив();
	Ожидание.Добавить(Справочники.бит_СтатусыОбъектов.ПустаяСсылка());
	Ожидание.Добавить(Справочники.бит_СтатусыОбъектов.Задача_Остановлена);
	
	Если Активные.Найти(ПараметрыТочки.Состояние) <> Неопределено Тогда
		passageState = "2";
	ИначеЕсли Выполненные.Найти(ПараметрыТочки.Состояние) <> Неопределено Тогда
		passageState = "1";
	ИначеЕсли Ожидание.Найти(ПараметрыТочки.Состояние) <> Неопределено Тогда
		passageState = "0";
	КонецЕсли;
	
	бит_УправлениеПроцессамиКлиентСервер.ВыделитьЭлемент(ГрафическаяСхема, 
		ПараметрыТочки.ИдентификаторТочки, passageState);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьСрокиИсполненияЗадач(ПараметрыТочки)

	Если НЕ ПоказыватьСрокиИсполненияЗадач Тогда
		Возврат;		
	КонецЕсли; 

	ДокументDOM = бит_УправлениеПроцессамиКлиентСервер.ГрафическаяСхемаВDOM(ГрафическаяСхема);
	
	ИдентификаторТочки = Строка(ПараметрыТочки.ИдентификаторТочки);
	УзелТочкиМаршрута  = бит_УправлениеПроцессамиКлиентСервер.ЭлементПоЗначениюСвойства(ДокументDOM, "itemId", ИдентификаторТочки);
	
	Если УзелТочкиМаршрута = Неопределено Тогда
		Возврат;	
	КонецЕсли; 
	
	content = бит_УправлениеПроцессамиКлиентСервер.ЗначениеСвойстваЭлемента(УзелТочкиМаршрута, "content");
	content = content + Символы.ПС + Нстр("ru = 'до '") 
			+ Формат(ПараметрыТочки.ДатаОкончания, "ДФ='dd.MM.yyyy HH:mm'; ДП=<неограничено>");
	бит_УправлениеПроцессамиКлиентСервер.УстановитьЗначениеСвойстваЭлемента(УзелТочкиМаршрута, "content", content);
	
	ГрафическаяСхема = бит_УправлениеПроцессамиКлиентСервер.ГрафическаяСхемаИзDOM(ДокументDOM);
	
КонецПроцедуры

// Процедура обрабатывет закрытие формы задачи. 
// 
// Параметры:
//  ТекущаяСтрока - ДанныеФормыСтруктура.
// 
&НаСервере
Процедура ДействияПриЗакрытииФормыЗадачи(ТекущаяСтрока)
	
	Если НЕ ТекущаяСтрока = Неопределено Тогда
		
		ДействияПриАктивизацииСтроки(ТекущаяСтрока.Алгоритм, ТекущаяСтрока.Ссылка);			
		
	КонецЕсли; 
	Элементы.Список.Обновить();
	
КонецПроцедуры // ДействияПриЗакрытииФормыЗадачи() 

// Процедура выполняет остановку или продолжение выполнения процесса после остановки. 
// 
// Параметры:
//  Процессы - Массив.
//  Режим - Строка
// 
&НаСервере
Функция ОстановитьВозобновитьПроцесс(Процессы, Режим)
	
	флОК = Ложь;
	
	Для каждого ТекПроцесс Из Процессы Цикл
		
		Если ТекПроцесс.Состояние = Справочники.бит_СтатусыОбъектов.Процесс_Активный И Режим = "Остановить" Тогда
			флВыполнено = БизнесПроцессы.бит_уп_Процесс.ОстановитьПроцесс(ТекПроцесс, "Ошибки");
		ИначеЕсли ТекПроцесс.Состояние = Справочники.бит_СтатусыОбъектов.Процесс_Остановлен И Режим = "Возобновить" Тогда	
			флВыполнено = БизнесПроцессы.бит_уп_Процесс.ПродолжитьПроцесс(ТекПроцесс);
		Иначе
			флВыполнено = Ложь;
		КонецЕсли; 
		
		Если флВыполнено Тогда
			
		    // Если удалось выполнить хотя бы для одного процесса - нужно обновить динамические списки.
			флОК = Истина;
		
		КонецЕсли; 
		
	КонецЦикла; 
	
	Возврат флОК;
	
КонецФункции // ОстановитьВозобновитьПроцесс()

// Процедура обновляет алгоритм и список процессов.
// 
// Параметры:
//  СтрПар - Структура.
// 
&НаСервере
Процедура ОбновитьВсе(СтрПар)
	
	Если НЕ СтрПар = Неопределено Тогда
		
		ДействияПриАктивизацииСтроки(СтрПар.Алгоритм, СтрПар.Ссылка);
		
	КонецЕсли; 
	
	Элементы.Список.Обновить();
	
КонецПроцедуры // ОбновитьВсе()

&НаКлиенте
Процедура ПоказыватьСрокиИсполненияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;	

	Если НЕ ТекущаяСтрока = Неопределено Тогда

		ДействияПриАктивизацииСтроки(ТекущаяСтрока.Алгоритм, ТекущаяСтрока.Ссылка, Истина);

	КонецЕсли; 
   
КонецПроцедуры


#КонецОбласти


