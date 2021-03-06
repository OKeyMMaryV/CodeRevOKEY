
////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит соответствие результатов формирования отчёта
&НаКлиенте
Перем мСоответствиеРезультатов;


////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
            
// бит_ASubbotina Процедура - обработчик события "ПриОткрытии" формы.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если фОтказ Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	мСоответствиеРезультатов = Новый Соответствие;
	
	Отчет.ДатаС = НачалоГода(ТекущаяДата());	
	Отчет.ДатаПо = КонецГода(ТекущаяДата());
	 	
КонецПроцедуры // ПриОткрытии()

// бит_ASubbotina Процедура - обработчик события "ОбработкаОповещения" формы.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ("СохраненаНастройка_" + фПолноеИмяОтчета) Тогда
		
		ОбновитьПанельСохраненныхНастроек(Истина, Параметр);
				
	КонецЕсли;
	
КонецПроцедуры // ОбработкаОповещения()


////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// бит_ASubbotina Процедура - обработчик команды "КомандаФильтроватьНастройкиПоВариантам"
//
&НаКлиенте
Процедура КомандаФильтроватьНастройкиПоВариантам(Команда)
	
	фФильтроватьНастройкиПоВарианту = Не фФильтроватьНастройкиПоВарианту;
	
	Элементы.КомандаФильтроватьНастройкиПоВариантам.Пометка = фФильтроватьНастройкиПоВарианту;
	ИзменитьФильтрНастроек(фФильтроватьНастройкиПоВарианту);
	
КонецПроцедуры // КомандаФильтроватьНастройкиПоВариантам()

// бит_ASubbotina Процедура - обработчик команды "КомандаПанельНастроек"
//
&НаКлиенте
Процедура КомандаПанельНастроек(Команда)
	
	фСкрытьПанельНастроек = Не фСкрытьПанельНастроек;
	
	Элементы.ФормаКомандаПанельНастроек.Пометка = Не фСкрытьПанельНастроек;
	Элементы.ГруппаПанельНастроек.Видимость     = Не фСкрытьПанельНастроек;	
	
КонецПроцедуры // КомандаПанельНастроек()

// бит_ASubbotina Процедура - обработчик команды "КомандаПанельСохраненныхНастроек"
//
&НаКлиенте
Процедура КомандаПанельСохраненныхНастроек(Команда)
	
	фСкрытьПанельСохранённыхНастроек = Не фСкрытьПанельСохранённыхНастроек;
	
	Элементы.ФормаКомандаПанельСохраненныхНастроек.Пометка   = Не фСкрытьПанельСохранённыхНастроек;
	Элементы.ГруппаПанельВыбораСохраненныхНастроек.Видимость = Не фСкрытьПанельСохранённыхНастроек;
	
КонецПроцедуры // КомандаПанельСохраненныхНастроек()

// бит_ASubbotina Процедура - обработчик команды "КомандаПанельСохраненныхНастроек"
//
&НаКлиенте
Процедура КомандаОбновитьПанельСохраненныхНастроек(Команда)
	
	ОбновитьПанельСохраненныхНастроек(Истина);	
	
КонецПроцедуры // КомандаОбновитьПанельСохраненныхНастроек()


// бит_ASubbotina Процедура - обработчик команды "Результат_ПоказатьВОтдельномОкне"
//
&НаКлиенте
Процедура Результат_ПоказатьВОтдельномОкне(Команда)
	
	бит_ОтчетыКлиент.ПоказатьКопиюРезультата(Результат);	
		
КонецПроцедуры // Результат_ПоказатьВОтдельномОкне()


////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// бит_ASubbotina Процедура - обработчик события "Нажатие" элемента формы "ДекорацияНастройки<№>".
//
&НаКлиенте
Процедура ДекорацияСохраненнойНастройкиНажатие(Элемент)
	
	// Сохраним результат
	Если ЗначениеЗаполнено(фИмяЭлемента_ВыбраннаяНастройка) 
		И фСтруктураСохраненныхНастроек.Свойство(фИмяЭлемента_ВыбраннаяНастройка) Тогда
		СтруктураСохр = Новый Структура("Результат, ДанныеРасшифровки", Результат, ДанныеРасшифровки);
		КлючНастройки = фСтруктураСохраненныхНастроек[фИмяЭлемента_ВыбраннаяНастройка].КлючНастройки;
		мСоответствиеРезультатов.Вставить(КлючНастройки, СтруктураСохр);
	КонецЕсли;
	
	// Обновление пользовательских настроек
	ИмяЭлемента = Элемент.Имя;
	НастройкиОбновлены = ОбновитьНастройки(ИмяЭлемента, мСоответствиеРезультатов);
	Если Не НастройкиОбновлены Тогда
		ТекстСообщения = Нстр("ru = 'Настройка не найдена. Обновите панель сохраненных настроек.'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения); 	
	КонецЕсли;
	
	бит_ОтчетыКлиент.ОбработатьНажатиеНаПолеСохраненнойНастройки(Элементы, 
																Элемент, 
																фИмяЭлемента_ВыбраннаяНастройка);
																	     			
КонецПроцедуры // ДекорацияСохраненнойНастройкиНажатие()


////////////////////////////////////////////////////////////////////////////
// СЕРВЕРНЫЕ ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// бит_ASubbotina Процедура - обработчик события "ПриСозданииНаСервере" формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Метаданные.Отчеты.бит_НРПВНА;
	
	// Вызов механизма защиты
	фПолноеИмяОтчета = МетаданныеОбъекта.ПолноеИмя();
	бит_ЛицензированиеБФCервер.ПроверитьВозможностьРаботы(ЭтаФорма, фПолноеИмяОтчета, фОтказ);
	
	фЗагружатьНастройки   = Истина;
	
	УправлениеВидимостьюДоступностью();
	
	ОбновитьПанельСохраненныхНастроек();
		
КонецПроцедуры // ПриСозданииНаСервере()

// бит_ASubbotina Процедура - обработчик события "ПриЗагрузкеДанныхИзНастроекНаСервере" формы.
//
&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	фСкрытьПанельНастроек 			 = Настройки.Получить("фСкрытьПанельНастроек");
	фСкрытьПанельСохранённыхНастроек = Настройки.Получить("фСкрытьПанельСохранённыхНастроек");
	фФильтроватьНастройкиПоВарианту  = Настройки.Получить("фФильтроватьНастройкиПоВарианту");
	
	// Видимость панели настроек
	Элементы.ФормаКомандаПанельНастроек.Пометка = Не фСкрытьПанельНастроек;	
	Элементы.ГруппаПанельНастроек.Видимость     = Не фСкрытьПанельНастроек;
	
	// Видимость панели сохранённых настроек
	Элементы.ФормаКомандаПанельСохраненныхНастроек.Пометка 	 = Не фСкрытьПанельСохранённыхНастроек;
	Элементы.ГруппаПанельВыбораСохраненныхНастроек.Видимость = Не фСкрытьПанельСохранённыхНастроек;
	
	// Фильтр сохранённых настроек по варианту
	Элементы.КомандаФильтроватьНастройкиПоВариантам.Пометка = фФильтроватьНастройкиПоВарианту;
	ИзменитьФильтрНастроек(фФильтроватьНастройкиПоВарианту);
	
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

// бит_ASubbotina Процедура - обработчик события "ПриСохраненииВариантаНаСервере" формы.
//
&НаСервере
Процедура ПриСохраненииВариантаНаСервере(Настройки)
	
	Если фКлючТекущегоВарианта <> КлючТекущегоВарианта Тогда
		УстановитьТекущийВариант(КлючТекущегоВарианта); 		
	КонецЕсли;
	
КонецПроцедуры // ПриСохраненииВариантаНаСервере()

// бит_ASubbotina Процедура - обработчик события "ПриЗагрузкеВариантаНаСервере" формы.
//
&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	фКлючТекущегоВарианта = КлючТекущегоВарианта;

	КлючОбъекта = ?(ЗначениеЗаполнено(КлючТекущегоВарианта), 
					фПолноеИмяОтчета + "/" + КлючТекущегоВарианта, 
					фПолноеИмяОтчета);
		
	бит_ОтчетыСервер.ИзменитьВидимостьСохраненныхНастроек(Элементы, фСтруктураСохраненныхНастроек, КлючОбъекта, фФильтроватьНастройкиПоВарианту);
	
	Если фЗагружатьНастройки Тогда
		
		// Установка настройки, используемой при открытии, если такая указана в справочнике
		КлючНастройкиПоУмолчанию = бит_ОтчетыСервер.НайтиНастройкуПоУмолчаниюДляОбъекта(КлючОбъекта, Истина);
		
		Если ЗначениеЗаполнено(КлючНастройкиПоУмолчанию) Тогда
			УстановитьТекущиеПользовательскиеНастройки(КлючНастройкиПоУмолчанию);
		Иначе
			УстановитьСтандартныеНастройкиСервер();
			фИмяЭлемента_ВыбраннаяНастройка = "";
		КонецЕсли;
			
		Результат.Очистить();
		
	КонецЕсли;
		
КонецПроцедуры // ПриЗагрузкеВариантаНаСервере()
 
// бит_ASubbotina Процедура - обработчик события "ПриЗагрузкеПользовательскихНастроекНаСервере" формы.
// 
&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	Если Настройки = Неопределено ИЛИ Не фЗагружатьНастройки Тогда 
		Возврат;
	КонецЕсли;
	
	Если Настройки.ДополнительныеСвойства.Свойство("КлючНастройки") Тогда
		ТекКлючНастройки = Настройки.ДополнительныеСвойства.КлючНастройки;
		бит_ОтчетыСервер.ВыделитьТекущуюСохраненнуюНастройку(Элементы, 
															фСтруктураСохраненныхНастроек, 
															фИмяЭлемента_ВыбраннаяНастройка,
															фФильтроватьНастройкиПоВарианту,
															ТекКлючНастройки);
	КонецЕсли;
			
КонецПроцедуры // ПриЗагрузкеПользовательскихНастроекНаСервере()


////////////////////////////////////////////////////////////////////////////
// СЕРВЕРНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// бит_ASubbotina Процедура управляет видимостью и доступностью элементов формы
//
// Параметры:
//  Нет
//
&НаСервере
Процедура УправлениеВидимостьюДоступностью()
	
	// Установка видимости и доступности элементов формы в зависимости от типа отчёта 
	// - обычный или расшифровка 
	бит_ОтчетыСервер.УстановитьВидимостьДоступностьЭлементов(Элементы, 
															Параметры.КлючВарианта, 
															Параметры.ПредставлениеВарианта);
		          	
КонецПроцедуры // УправлениеВидимостьюДоступностью()

// бит_ASubbotina Процедура включает/отключает фильтр настроек по варианту
//
// Параметры:
//  Фильтровать  - Булево
//
&НаСервере
Процедура ИзменитьФильтрНастроек(Фильтровать)

	КлючОбъекта = ?(ЗначениеЗаполнено(КлючТекущегоВарианта), 
					фПолноеИмяОтчета + "/" + КлючТекущегоВарианта, 
					фПолноеИмяОтчета);
	бит_ОтчетыСервер.ИзменитьВидимостьСохраненныхНастроек(Элементы, фСтруктураСохраненныхНастроек, КлючОбъекта, фФильтроватьНастройкиПоВарианту);	

КонецПроцедуры // ИзменитьФильтрНастроек()

// бит_ASubbotina Функция обновляет настройки отчета
//
// Параметры:
//  ИмяЭлемента  		 	- Строка
//  СоответствиеРезультатов - Соответствие
//
// ВозращаемоеЗначение:
//  Булево - настройки обновлены
//
&НаСервере
Функция ОбновитьНастройки(ИмяЭлемента, СоответствиеРезультатов)

	НастройкиОбновлены = Ложь;
	
	Результат.Очистить();
	
	СтруктураНастроек = фСтруктураСохраненныхНастроек[ИмяЭлемента];
	
	Настройки = бит_ОтчетыСервер.ПолучитьНастройкиОтчета(СтруктураНастроек);
	
	Если Настройки <> Неопределено Тогда
			
		КлючНастройки = СтруктураНастроек.КлючНастройки;    	
		КлючОбъекта = СтрЗаменить(СтруктураНастроек.КлючОбъекта, фПолноеИмяОтчета + "/", "");
		
		Если КлючОбъекта <> КлючТекущегоВарианта Тогда
			фЗагружатьНастройки = Ложь;	
			УстановитьТекущийВариант(КлючОбъекта);
			фЗагружатьНастройки = Истина;
		КонецЕсли;
		
		УстановитьТекущиеПользовательскиеНастройки(КлючНастройки);
		НастройкиОбновлены = Истина;
		
	КонецЕсли;
	
	// Выведем результат, если он уже формировался для текущей настройки
	Если НастройкиОбновлены Тогда		
		СтруктураРез = СоответствиеРезультатов.Получить(КлючНастройки);
		Если СтруктураРез <> Неопределено Тогда
			Результат.Вывести(СтруктураРез.Результат);
			ДанныеРасшифровки = СтруктураРез.ДанныеРасшифровки;
		КонецЕсли; 		
	КонецЕсли;
	       	
	Возврат НастройкиОбновлены;

КонецФункции // ОбновитьНастройки()

// бит_ASubbotina Процедура обновляет панель сохраненных настроек
//
// Параметры:
//  Очищать  - Булево (Необязательный, по умолчанию = Ложь)
//  ТекКлючНастройки  (Необязательный)
//
&НаСервере
Процедура ОбновитьПанельСохраненныхНастроек(Очищать = Ложь, ТекКлючНастройки = Неопределено)

	ГруппаПанели = Элементы.ГруппаПанельВыбораСохраненныхНастроек;
	
	СтруктураДоступности = бит_ОтчетыСервер.ПроверитьДоступностьВариантовНастроек(фПолноеИмяОтчета, Истина);
	лИспользуемыйПриОткрытииВариант = СтруктураДоступности.ИспользуемыйПриОткрытииВариант;
		
	Если Очищать Тогда 	
		
		бит_РаботаСДиалогамиСервер.УдалитьЭлементыГруппыФормы(Элементы, ГруппаПанели); 			
		
	Иначе
		
		Если лИспользуемыйПриОткрытииВариант = Неопределено Тогда
			КлючТекущегоВарианта = "";
			Возврат;
		Иначе
			КлючТекущегоВарианта = лИспользуемыйПриОткрытииВариант;		
		КонецЕсли;
	
	КонецЕсли; 	
	
	КлючОбъекта = 	фПолноеИмяОтчета + "/" + КлючТекущегоВарианта;
		
	бит_ОтчетыСервер.ОбновитьПанельСохраненныхНастроек(Элементы, 
													ГруппаПанели, 
													КлючОбъекта, 
													фСтруктураСохраненныхНастроек,
													СтруктураДоступности,
													фФильтроватьНастройкиПоВарианту,
													фИмяЭлемента_ВыбраннаяНастройка);
	
	Если ТекКлючНастройки <> Неопределено Тогда
		
		бит_ОтчетыСервер.ВыделитьТекущуюСохраненнуюНастройку(Элементы, 
															фСтруктураСохраненныхНастроек, 
															фИмяЭлемента_ВыбраннаяНастройка,
															фФильтроватьНастройкиПоВарианту,
															ТекКлючНастройки);	
		
	Иначе
		фИмяЭлемента_ВыбраннаяНастройка = "";														
	КонецЕсли;
	
КонецПроцедуры // ОбновитьПанельСохраненныхНастроек()

// бит_ASubbotina Процедура устанавливает стандартные настройки варианта 
// и обновляет по ним элементы формы.
// Заменяет типовую команду "СтандартныеНастройки".
//
&НаСервере
Процедура УстановитьСтандартныеНастройкиСервер(ВосстанавливатьНастройки = Ложь, фСписокПараметровНаФорме = Неопределено)
	
	бит_ОтчетыСервер.УстановитьСтандартныеНастройкиСервер(Отчет, ВосстанавливатьНастройки, фСписокПараметровНаФорме);
		
	бит_ОтчетыСервер.ВыделитьТекущуюСохраненнуюНастройку(Элементы, 
														фСтруктураСохраненныхНастроек, 
														фИмяЭлемента_ВыбраннаяНастройка,
														фФильтроватьНастройкиПоВарианту);
															
КонецПроцедуры // УстановитьСтандартныеНастройкиСервер()

// Создает ИсточникДоступныхНастроекКомпоновкиДанных с помощью URL													
&НаСервере
Функция ИсточникДоступныхНастроекПолучить(СхемаКомпоновкиДанных)
	// Поместим схему во временное хранилище
	URLСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных);
	// Создадим источник
	Возврат Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы);
КонецФункции



&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыполненноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.Нет;
	ПараметрВыполненногоДействия = Неопределено;
	
	мДанныеРасшифровкиЗначениеПоля = ПолучитьРасшифровкуНаСервере(Расшифровка);
	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(ДанныеРасшифровки, Новый ИсточникДоступныхНастроекКомпоновкиДанных(Отчет));
	ДополнительныеДействия = Новый СписокЗначений;
	
	Если мДанныеРасшифровкиЗначениеПоля = "Приход"
		ИЛИ мДанныеРасшифровкиЗначениеПоля = "Расход"
		ИЛИ мДанныеРасшифровкиЗначениеПоля = "Остаток"
		ИЛИ мДанныеРасшифровкиЗначениеПоля = "ОстатокНаКонец" Тогда                                                                               
		ДополнительныеДействия.Добавить("ОткрытьНРПВНА","НРП ВНА");  // добавляем свое действие
	КонецЕсли;
	//ОбработкаРасшифровки = РезультатВыполненияОтчета.Свойство(ОбработкаРасшифровки);
	
	ОбработкаРасшифровки.ВыбратьДействие(Расшифровка, ВыполненноеДействие, ПараметрВыполненногоДействия,, ДополнительныеДействия);
	
	Если ВыполненноеДействие <> ДействиеОбработкиРасшифровкиКомпоновкиДанных.Нет Тогда
		Если ВыполненноеДействие="ОткрытьНРПВНА" Тогда
			ВыполнитьДействие1(Расшифровка);      // процедура выполняемая при выборе пункта меню "Дополнительное действие 1"
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает массив, по которому следует расшифровать отчет
&НаСервере
Функция ПолучитьМассивПолейРасшифровки(Расшифровка, ТекущийОтчет = Неопределено, ВключатьРесурсы = Ложь) Экспорт
	
	мДанныеРасшифровки = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	МассивПолейРасшифровки = Новый Массив;
	
	Если ТипЗнч(Расшифровка) <> Тип("ИдентификаторРасшифровкиКомпоновкиДанных") 
		И ТипЗнч(Расшифровка) <> Тип("ДанныеРасшифровкиКомпоновкиДанных") Тогда
		Возврат МассивПолейРасшифровки;
	КонецЕсли;
	
	Если ТекущийОтчет = Неопределено Тогда
		ТекущийОтчет = мДанныеРасшифровки;
	КонецЕсли;
	
	// Добавим поля родительских группировок
	ДобавитьРодителей(мДанныеРасшифровки.Элементы[Расшифровка], ТекущийОтчет, МассивПолейРасшифровки, ВключатьРесурсы);
	
	Количество = МассивПолейРасшифровки.Количество();
	Для Индекс = 1 По Количество Цикл
		ОбратныйИндекс = Количество - Индекс;
		Для ИндексВнутри = 0 По ОбратныйИндекс - 1 Цикл
			Если МассивПолейРасшифровки[ОбратныйИндекс].Поле = МассивПолейРасшифровки[ИндексВнутри].Поле Тогда
				МассивПолейРасшифровки.Удалить(ОбратныйИндекс);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// Добавим отбор, установленный в отчете
	Для каждого ЭлементОтбора Из ТекущийОтчет.Настройки.Отбор.Элементы Цикл
		Если Не ЭлементОтбора.Использование Тогда
			Продолжить;
		КонецЕсли;
		МассивПолейРасшифровки.Добавить(ЭлементОтбора);
	КонецЦикла;
	
	Возврат МассивПолейРасшифровки;
	
КонецФункции

&НаСервере
Функция ДобавитьРодителей(ЭлементРасшифровки, ТекущийОтчет, МассивПолейРасшифровки, ВключатьРесурсы = Ложь)  Экспорт
	
	Если ТипЗнч(ЭлементРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		Для каждого Поле Из ЭлементРасшифровки.ПолучитьПоля() Цикл
			ДоступноеПоле = ПолучитьДоступноеПолеПоПолюКомпоновкиДанных(Новый ПолеКомпоновкиДанных(Поле.Поле), ТекущийОтчет);
			Если ДоступноеПоле = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Если Не ВключатьРесурсы И ДоступноеПоле.Ресурс Тогда
				Продолжить;
			КонецЕсли;
			МассивПолейРасшифровки.Добавить(Поле);
		КонецЦикла;
	КонецЕсли;
	Для каждого Родитель Из ЭлементРасшифровки.ПолучитьРодителей() Цикл
		ДобавитьРодителей(Родитель, ТекущийОтчет, МассивПолейРасшифровки, ВключатьРесурсы);
	КонецЦикла;
	
КонецФункции


// Возвращает доступное поле по полю компоновки
&НаСервере
Функция ПолучитьДоступноеПолеПоПолюКомпоновкиДанных(ПолеКомпоновкиДанных, ОбластьПоиска)
	
	Если ТипЗнч(ПолеКомпоновкиДанных) = Тип("Строка") Тогда
		ПолеПоиска = Новый ПолеКомпоновкиДанных(ПолеКомпоновкиДанных);
	Иначе
		ПолеПоиска = ПолеКомпоновкиДанных;
	КонецЕсли;
	
	Если ТипЗнч(ОбластьПоиска) = Тип("КомпоновщикНастроекКомпоновкиДанных")
		ИЛИ ТипЗнч(ОбластьПоиска) = Тип("ДанныеРасшифровкиКомпоновкиДанных")
		ИЛИ ТипЗнч(ОбластьПоиска) = Тип("НастройкиВложенногоОбъектаКомпоновкиДанных") Тогда
		Возврат ОбластьПоиска.Настройки.ДоступныеПоляВыбора.НайтиПоле(ПолеПоиска);
	Иначе
		Возврат ОбластьПоиска.НайтиПоле(ПолеПоиска);
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьДействие1(Расшифровка)
	
	ФормаРегистра = ПолучитьФорму("РегистрСведений.бит_му_НРП_ВНА.Форма.ФормаСписка");
	
	ФормаРегистраНастройкиКОткрытиюПодготовить(ФормаРегистра.Список, Расшифровка);
	
	ОтборУстановитьПериод(ФормаРегистра.Список);
	
	ФормаРегистра.Открыть();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоОбъекту(СписокФормы, НазваниеДляСубконто, Счет, Объект)
	
	Если НЕ ЗначениеЗаполнено(Счет) Тогда
		Возврат
	КонецЕсли;
	
	ВидыСубконто = Счет.ВидыСубконто;
	СубконтоОбъект = ВидыСубконто.Найти(ПланыВидовХарактеристик.бит_ВидыСубконтоДополнительные_2.Объект);
	
	Если СубконтоОбъект = Неопределено Тогда
		Возврат
	Иначе
		НомерСтрокиОбъекта = СубконтоОбъект.НомерСтроки;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокФормы, НазваниеДляСубконто, Объект, ВидСравненияКомпоновкиДанных.Равно,, Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРасшифровкуНаСервере(Расшифровка)
	
	Данные = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	Возврат Данные.Элементы[Расшифровка].ПолучитьПоля()[0].Поле;
	
КонецФункции

// Устанавливается период отбора
&НаКлиенте
Функция ОтборУстановитьПериод(СписокФормы)
	// 1c-izthc Гвоздиков Ф. 22.09.2015 (
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокФормы, "Период", Отчет.ДатаС, ВидСравненияКомпоновкиДанных.БольшеИлиРавно,, Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокФормы, "Период", КонецДня(Отчет.ДатаПо), ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,, Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	// 1c-izthc Гвоздиков Ф. 22.09.2015 )
КонецФункции

// Подготавливает настройки формы для открытия списка НРПВНА
&НаСервере
Функция ФормаРегистраНастройкиКОткрытиюПодготовить(СписокФормы, Расшифровка)
	
	МассивПолейРасшифровки = ПолучитьМассивПолейРасшифровки(Расшифровка);
	
	СписокФормы.Отбор.Элементы.Очистить();
	
	Счет = ПланыСчетов.бит_Дополнительный_2.ПустаяСсылка();
	КлассСчета = "";
	ДокументПоступления = Неопределено;
	ДокументРеализации  = Неопределено;
	ОрганизацияЗаказчик = ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"); 
	ОрганизацияПодрядчик = ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"); 
	Объект = Отчет.ОбъектОС;
	
	Для Каждого ЭлементМассива ИЗ МассивПолейРасшифровки Цикл
		Если ЭлементМассива.Поле = "Счет" Тогда
			Счет = ЭлементМассива.Значение;
		КонецЕсли;
		Если ЭлементМассива.Поле = "КлассСчета" Тогда
			КлассСчета = ЭлементМассива.Значение;
		КонецЕсли;
		Если ЭлементМассива.Поле = "ОрганизацияЗаказчик" Тогда
			ОрганизацияЗаказчик = ЭлементМассива.Значение;
		КонецЕсли;
		Если ЭлементМассива.Поле = "ОрганизацияПодрядчик" Тогда
			ОрганизацияПодрядчик = ЭлементМассива.Значение;
		КонецЕсли;
		Если ЭлементМассива.Поле = "ДокументПоступления" Тогда
			ДокументПоступления = ЭлементМассива.Значение;
		КонецЕсли;
		Если ЭлементМассива.Поле = "ДокументРеализации" Тогда
			ДокументРеализации = ЭлементМассива.Значение;
		КонецЕсли;
		Если ЭлементМассива.Поле = "Объект" Тогда
			Объект = ЭлементМассива.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(КлассСчета) Тогда
		НазваниеДляСчета = СтрЗаменить(КлассСчета, " ", "");
		НазваниеДляСубконто = СтрЗаменить(СтрЗаменить(КлассСчета, "Счет ", ""), " ", "");
		// 1c-izthc Гвоздиков Ф. 22.09.2015 (
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокФормы, НазваниеДляСчета, Счет, ВидСравненияКомпоновкиДанных.Равно,, Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
		// 1c-izthc Гвоздиков Ф. 22.09.2015 )
		Если ЗначениеЗаполнено(Объект) Тогда
			УстановитьОтборПоОбъекту(СписокФормы, НазваниеДляСубконто, Счет, Объект);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Отчет.ОрганизацияЗаказчик) Тогда
		// 1c-izthc Гвоздиков Ф. 10.09.2015 (
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокФормы, "ОрганизацияЗаказчик", Отчет.ОрганизацияЗаказчик, ВидСравненияКомпоновкиДанных.Равно,, Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
		// 1c-izthc Гвоздиков Ф. 10.09.2015 )
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Отчет.ОрганизацияПодрядчик) Тогда
		// 1c-izthc Гвоздиков Ф. 10.09.2015 (
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокФормы, "ОрганизацияПодрядчик",  Отчет.ОрганизацияПодрядчик, ВидСравненияКомпоновкиДанных.Равно,, Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
		// 1c-izthc Гвоздиков Ф. 10.09.2015 )
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДокументПоступления) Тогда
		// 1c-izthc Гвоздиков Ф. 10.09.2015 (
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокФормы, "ДокументПоступления",  ДокументПоступления, ВидСравненияКомпоновкиДанных.Равно,, Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
		// 1c-izthc Гвоздиков Ф. 10.09.2015 )
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДокументРеализации) Тогда
		// 1c-izthc Гвоздиков Ф. 10.09.2015 (
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокФормы, "ДокументРеализации",  ДокументРеализации, ВидСравненияКомпоновкиДанных.Равно,, Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
		// 1c-izthc Гвоздиков Ф. 10.09.2015 )
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПолучитьМакетНаСервере()
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	Макет = ОтчетОбъект.ПолучитьМакет("Макет");
	Возврат Макет;
КонецФункции
