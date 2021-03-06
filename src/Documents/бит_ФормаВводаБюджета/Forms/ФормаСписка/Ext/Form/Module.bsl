
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//1С-ИжТиСи, Кондратьев, 03.2020, обновление, некомментированный исправленный код (
	ИжТиСи_СВД_Сервер.ОК_ВывестиРеквизиты(ЭтаФорма, "Документ.бит_ФормаВводаБюджета.ФормаСпискаУправляемая");
	//1С-ИжТиСи, Кондратьев, 03.2020, обновление, некомментированный исправленный код )
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
    
	// Стандартные действия при создании на сервере.
	//бит_РаботаСДиалогамиСервер.СписокПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма);  //ОК Довбешка Т. 29.11.2017
	
	//1С-ИжТиСи, Кондратьев, 03.2020, обновление, некомментированный исправленный код (
	// Заполняем кэш значений.
	ЗаполнитьКэшЗначений(мКэшЗначений);
	//1С-ИжТиСи, Кондратьев, 03.2020, обновление, некомментированный исправленный код )
	
	МетаданныеОбъекта = Метаданные.Документы.бит_ФормаВводаБюджета;
	
	// Добавление кнопки "Раскрасить по статусам".
	// Также добавляются процедуры: К-Подключаемый_РаскраситьПоСтатусам(), С-ОформитьСписокДокументовПоСтатусам().
	бит_РаботаСДиалогамиСервер.ДобавитьКнопкуРаскраситьПоСтатусам(Элементы, Команды, Элементы.ГруппаКоманднаяПанель,
																  МетаданныеОбъекта);
	ОформитьСписокДокументовПоСтатусам(Элементы.РаскраситьПоСтатусам.Пометка, Истина);
	
	//+СБ. ПискуноваВ #2691 25.05.2017	
	СБ_РаботаСФормамиОбъекты.бит_ФормаВводаБюджетаФормаСпискаУправляемаяПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	//-СБ. ПискуноваВ #2691 25.05.2017
	                                
	//ОКЕЙ Морозов А.В. (СофтЛаб) Начало 2020-09-02 (#3775)
	ОК_ОбщегоНазначения.ДобавитьКомандуФормы(Команды, "СформироватьОтчетПоБюджетуДляОЦР", НСтр("ru = 'Отчет по бюджету для ОЦР'"), "СформироватьОтчетПоБюджетуДляОЦР");
	ОК_ОбщегоНазначения.ВывестиКомандуНаФорму(ЭтаФорма, "СформироватьОтчетПоБюджетуДляОЦР", "СформироватьОтчетПоБюджетуДляОЦР", НСтр("ru = 'Отчет по бюджету для ОЦР'"), Элементы.ГруппаКоманднаяПанель,,);
	//ОКЕЙ Морозов А.В. (СофтЛаб) Конец 2020-09-02 (#3775)

	// ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2021-10-19 (#4390)
	ок_УправлениеФормами.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	// ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2021-10-19 (#4390)
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область СтандартныеПодсистемыОбработчикиКоманд

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

// Процедура назначается динамически действию кнопки командной панели 
// КоманднаяПанель.РаскраситьПоСтатусам
// (обработчик события "Нажатие" кнопки "РаскраситьПоСтатусам").
// 
&НаКлиенте
Процедура Подключаемый_РаскраситьПоСтатусам()
	
	Элементы.РаскраситьПоСтатусам.Пометка = Не Элементы.РаскраситьПоСтатусам.Пометка;
	ОформитьСписокДокументовПоСтатусам(Элементы.РаскраситьПоСтатусам.Пометка);	
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура обновляет оформление списка документов по статусам.
// 
// Параметры:
//  ТолькоОчистить - Булево. 
// 
&НаСервере
Процедура ОформитьСписокДокументовПоСтатусам(ПометкаКн, ЭтоОткрытие = Ложь)

	Если ЭтоОткрытие И Не ПометкаКн Тогда
		Возврат;	
	КонецЕсли;
	
	МетаданныеОбъекта = Метаданные.Документы.бит_ФормаВводаБюджета;	
	
	МасОбъектов = ?(ПометкаКн, бит_РаботаСДиалогамиСервер.ПолучитьМассивОбъектов(МетаданныеОбъекта), Новый Массив);
	бит_РаботаСДиалогамиСервер.ОформитьСписокДокументовПоСтатусам(МасОбъектов, ПометкаКн, ЭтаФорма.УсловноеОформление);
	
	Если Не ЭтоОткрытие Тогда
		// Сохранение значения пометки.
		РегистрыСведений.бит_СохраненныеЗначения.СохранитьЗнч(бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь")
																	,МетаданныеОбъекта
																	,"РаскраситьПоСтатусам_Пометка"
																	,ПометкаКн);
	КонецЕсли;
															
КонецПроцедуры

#КонецОбласти   

//1С-ИжТиСи, Кондратьев, 03.2020, обновление, некомментированный исправленный код (
&НаКлиенте
Процедура бит_ДействияФормыВвестиНаОсновании()
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	//Задаем вопрос - какую сумму переносить?
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.Добавить("Сверхбюджета", "Только сверхбюджета");
	СписокВыбора.Добавить("Полностью", "Полностью");
	
	СписокВыбора.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("бит_ДействияФормыВвестиНаОснованииЗавершение", ЭтотОбъект), "Какую сумму вы хотите перенести в заявку?");
КонецПроцедуры

&НаКлиенте
Процедура бит_ДействияФормыВвестиНаОснованииЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполнения = ПолучитьЗначенияЗаполненияВНО(Элементы.Список.ТекущаяСтрока, ВыбранныйЭлемент.Значение);
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Документ.бит_БК_КорректировкаКонтрольныхЗначенийИБюджета.Форма.ФормаДокумента", ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЗначенияЗаполненияВНО(Ссылка, ВыборСуммы) Экспорт
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("ДокОснование",Ссылка);
	
	//Начало_бит_Магомедов_09.08.2012 
	//Заполняем аналитику НомерЗаявки в соотв. со сценарием
	ТЗСтрок = Ссылка.БДДС.Выгрузить();
	Если Ссылка.Сценарий = Справочники.СценарииПланирования.Заявка_Инвест ИЛИ Ссылка.Сценарий = Справочники.СценарииПланирования.Заявка_У Тогда 
		ТЗСтрок.ЗаполнитьЗначения(Документы.бит_ФормаВводаБюджета.ПустаяСсылка(),"Аналитика_1");
	ИначеЕсли Ссылка.Сценарий = Справочники.СценарииПланирования.Контракт_Инвест Тогда  
		ТЗСтрок.ЗаполнитьЗначения(Ссылка.бит_БК_НомерЗаявки,"Аналитика_1");
	КонецЕсли;	
	//Конец_бит_Магомедов_09.08.2012 
	
	ДанныеЗаполнения.Вставить("МассивСтрокПревышения", ПоместитьВоВременноеХранилище(ТЗСтрок, УникальныйИдентификатор));
	ДанныеЗаполнения.Вставить("ВыборСуммы", ВыборСуммы);
	//ОК Ванюков К. +// Исправление ошибки. Переменная рабочая дата доступна только на клиенте // 2012-08-15
	//ДанныеЗаполнения.Вставить("Дата", РабочаяДата);
	//#Если Клиент Тогда
	//	ДанныеЗаполнения.Вставить("Дата", РабочаяДата);
	//#Иначе
	ДанныеЗаполнения.Вставить("Дата", ТекущаяДата());
	//#КонецЕсли
	//ОК Ванюков К. -	
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

&НаКлиенте
Процедура НайтиДокумент(Команда)
	Ссылка = НайтиНажатиеНаСервере(НайтиПоНомеру);
	Если ЗначениеЗаполнено(Ссылка) Тогда 
		Элементы.Список.ТекущаяСтрока = Ссылка;
	Иначе
		ПоказатьПредупреждение(Неопределено, "Заявка не найдена");
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиНажатиеНаСервере(НайтиПоНомеру)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	бит_ФормаВводаБюджета.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.бит_ФормаВводаБюджета КАК бит_ФормаВводаБюджета
	|ГДЕ
	|	бит_ФормаВводаБюджета.Номер = &Номер
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка УБЫВ
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("Номер", НайтиПоНомеру);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.Ссылка;
	Иначе 
		Возврат Неопределено
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
	// ПараметрыФормы.Вставить("СтруктураПараметров", Новый Структура);
	
	Если Копирование Тогда 		
		СтруктураПараметров = Новый Структура;
	иначе
		
		СформироватьДеревоВидовОперацийДляЗаявки(мКэшЗначений.Перечисления.бит_БК_ВидыОперацийФормаВводаБюджета);
		Оповещение = Новый ОписаниеОповещения("СписокПередНачаломДобавленияЗавершение", ЭтотОбъект, Ложь); 
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СсылкаДокумента"    , ПустойОбъект);
		ПараметрыФормы.Вставить("ДеревоВидовОпераций", ДеревоВидовОпераций);
		ОткрытьФорму("ОбщаяФорма.бит_ФормаВыбораВидаОперацииИзДереваУправляемая", ПараметрыФормы, ЭтаФорма,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Возврат;
		
	КонецЕсли;	
	
	СписокПередНачаломДобавленияЗавершение(СтруктураПараметров, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавленияЗавершение(СтруктураПараметров, Копирование) Экспорт 
	
	Если СтруктураПараметров = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	Если Копирование Тогда 
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элементы.Список.ТекущаяСтрока);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("СтруктураПараметров", СтруктураПараметров);
	
	ОткрытьФорму("Документ.бит_ФормаВводаБюджета.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоВидовОперацийДляЗаявки(ОбъектЗаполнения
	,Исключения 	= Неопределено
	,ВеткиДляВывода = "все") Экспорт
	
	Если ТипЗнч(Исключения) <> Тип("Структура") Тогда
		Исключения = Новый Структура;
	КонецЕсли;
	
	ДеревоВидовОперацийИсточник = Новый ДеревоЗначений;
	
	ДеревоВидовОперацийИсточник.Колонки.Добавить("ВидОперации");
	ДобавитьВеткуДереваВидыОпераций(ДеревоВидовОперацийИсточник
	,"Виды операций БК"
	,ОбъектЗаполнения
	,Исключения
	);
	
	ЗначениеВРеквизитФормы(ДеревоВидовОперацийИсточник, "ДеревоВидовОпераций");
	
КонецПроцедуры // СформироватьДеревоВидовОперацийДляЗаявки()

&НаСервереБезКонтекста 
Процедура ДобавитьВеткуДереваВидыОпераций(ДеревоВидыОпераций									
	,ВидОперацииГруппа
	,ОбъектЗаполнения
	,МассивИсключений
	)
	
	Если Не ТипЗнч(МассивИсключений) = Тип("Массив") Тогда
		МассивИсключений = Новый Массив;
	КонецЕсли; 
	
	// Добавляем строку верхнего уровня.
	СтрокаГруппа = ДеревоВидыОпераций.Строки.Добавить();
	СтрокаГруппа.ВидОперации = ВидОперацииГруппа;
	
	Для Каждого КлючЗначение Из ОбъектЗаполнения Цикл
		
		ЗначениеПеречисления = КлючЗначение.Значение;
		
		//Если Не СоответствиеКонтроль[ЗначениеПеречисления] = Неопределено Тогда
		
		Если МассивИсключений.Найти(ЗначениеПеречисления) = Неопределено Тогда
			
			НоваяСтрока = СтрокаГруппа.Строки.Добавить();
			НоваяСтрока.ВидОперации = ЗначениеПеречисления;
			
		КонецЕсли;
		
		//КонецЕсли; 
		
	КонецЦикла; // по объектам заполнения
	
КонецПроцедуры // ДобавитьВеткуДереваВидыОпераций()

&НаСервере
Процедура ЗаполнитьКэшЗначений(КэшированныеЗначения)
	КэшированныеЗначения = Новый Структура;
	
	// Перечисления.
	КэшПеречисления = Новый Структура;
	КэшПеречисления.Вставить("бит_БК_ВидыОперацийФормаВводаБюджета"   , бит_ОбщегоНазначения.КэшироватьЗначенияПеречисления(Перечисления.бит_БК_ВидыОперацийФормаВводаБюджета));
	
	КэшированныеЗначения.Вставить("Перечисления", КэшПеречисления);
КонецПроцедуры
//1С-ИжТиСи, Кондратьев, 03.2020, обновление, некомментированный исправленный код )

//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2017-08-25 (#2873)
Функция НуженВопросОчисткаАлгоритма(Массив)
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	бит_ФормаВводаБюджета.Ссылка
	|ИЗ
	|	Документ.бит_ФормаВводаБюджета КАК бит_ФормаВводаБюджета
	|ГДЕ
	|	бит_ФормаВводаБюджета.Проведен
	|	И бит_ФормаВводаБюджета.СБ_ПроцессЗапущен
	|	И бит_ФормаВводаБюджета.Ссылка В (&Массив)");
	Запрос.УстановитьПараметр("Массив"	,	Массив);
	Результат = Запрос.Выполнить();
	
	Возврат Не Результат.Пустой();
	
КонецФункции
//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2017-08-25 (#2873)

//1С-ИжТиСи, Кондратьев, 03.2020, обновление, некомментированный исправленный код (
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	//{ bit SVKushnirenko Bit 01.02.2017 #2657
	Если ИмяСобытия = "бит_БК_ИзмСтатусаПослеИзмБалансаЗаявок" Тогда //Обновление статусов на списках если это возможно
		
		Элементы.Список.Обновить();
	КонецЕсли; 
	//} bit SVKushnirenko Bit 01.02.2017 #2657
КонецПроцедуры

&НаКлиенте
Процедура СБ_ОтменитьПроведение(Команда)
	
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2017-08-25 (#2873)
	НуженВопросОчисткаАлгоритма = Ложь;
	Массив =  Элементы.Список.ВыделенныеСтроки;
	Если Массив.Количество()>0 Тогда 
		НуженВопросОчисткаАлгоритма = НуженВопросОчисткаАлгоритма(Массив);
	КонецЕсли;
	
	Если Не НуженВопросОчисткаАлгоритма Тогда 
		СБ_ОтменитьПроведениеНаСервере(Массив);	
		Элементы.Список.Обновить(); 
		Возврат;
	КонецЕсли;
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2017-08-25 (#2873)
	
	Результат = Вопрос("После отмены проведения будет очищен алгоритм. Продолжить?", РежимДиалогаВопрос.ДаНет);
	Если  Результат = КодВозвратаДиалога.Нет Тогда
		Отказ = Истина;
	Иначе
		Массив =  Элементы.Список.ВыделенныеСтроки;
		СБ_ОтменитьПроведениеНаСервере(Массив);	
		Элементы.Список.Обновить();  		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СБ_ОтменитьПроведениеНаСервере(МассивДокументов) 
	
	Для каждого Документ из МассивДокументов Цикл 
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2017-09-01 (#2873)
		Если НЕ Документ.Проведен Тогда 
			Продолжить;
		КонецЕсли;
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2017-09-01 (#2873)
		лДок = Документ.ПолучитьОбъект();
		лДок.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	КонецЦикла;
	
КонецПроцедуры 
//1С-ИжТиСи, Кондратьев, 03.2020, обновление, некомментированный исправленный код )

//ОКЕЙ Морозов А.В. (СофтЛаб) Начало 2020-09-02 (#3775)
&НаКлиенте
Процедура СформироватьОтчетПоБюджетуДляОЦР(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПривилегированныйРежим", 	Истина);  //Для отборов
	ПараметрыФормы.Вставить("ТолстыйКлиент", 			Истина);  
	ОткрытьФорму("Отчет.ок_ОтчетДляОЦРПоБюджету.Форма.ФормаОтчета", ПараметрыФормы);
	
КонецПроцедуры
//ОКЕЙ Морозов А.В. (СофтЛаб) Конец 2020-09-02 (#3775)