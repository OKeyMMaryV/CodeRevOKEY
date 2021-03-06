
#Область ОписаниеПеременных

&НаКлиенте
Перем мСоответствиеРезультатов; // Хранит соответствие результатов формирования отчета.

&НаКлиенте
Перем мТекущийВидСравнения; // Служит для передачи вида сравнения между обработчиками.

&НаКлиенте
Перем ПредВидСравненияСценарий; // Служит для передачи вида сравнения между обработчиками.

&НаКлиенте
Перем ПредВидСравненияОрганизация; // Служит для передачи вида сравнения между обработчиками.

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект, Отчет);
	
	фПолноеИмяОтчета = бит_ОбщегоНазначения.ПолучитьИмяОбъектаПоИмениФормы(ЭтотОбъект.ИмяФормы, Истина);
	фКлючОбъекта = фПолноеИмяОтчета + "_Построитель";
			
	// Вызов механизма защиты
	
	
	ЗаполнитьКэшЗначений();      	
	
	// Если это обработка расшифровки 
	Если Параметры.ЭтоОбработкаРасшифровки Тогда
		
		бит_БухгалтерскиеОтчетыСервер.ЗаполнитьОтчетПоПараметрамРасшифровки(Отчет, ЭтотОбъект, Параметры.Расшифровка);
				
	Иначе
		
		ОбновитьПанельСохраненныхНастроек(, Истина);
	КонецЕсли;   

	ОтчетОбъект = ЭтотОбъект.РеквизитФормыВЗначение("Отчет");
	Если Не ЗначениеЗаполнено(ЭтотОбъект.СхемаКомпоновкиДанных) Тогда
		ЭтотОбъект.СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(ОтчетОбъект.СхемаКомпоновкиДанных, ЭтотОбъект.УникальныйИдентификатор);
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ЭтотОбъект.фИмяЭлемента_ВыбраннаяНастройка) Тогда
		ОтчетОб = ДанныеФормыВЗначение(Отчет, Тип(фКэшЗначений.ИмяТипаОбъекта));	
		ОтчетОб.УстановитьЗначенияНастроекОтчетаПоУмолчанию(Отчет, ЭтотОбъект, ЭтотОбъект.фКэшЗначений.ИмяТипаОбъекта);
	КонецЕсли;
	
	УправлениеВидимостьюДоступностью();
		
	// Формирование отчета при открытии, если требуется.
	Если Параметры.СформироватьПриОткрытии = Истина Тогда
		ОбновитьОтчет();
		Параметры.СформироватьПриОткрытии = Ложь;
	КонецЕсли;
	
		
	бит_БухгалтерскиеОтчетыСервер.ЗаполнитьСписокВыбораВидаСравненияДляСценария(Элементы.СценарийВидСравнения.СписокВыбора);
	
	// Изменение кода. Начало. 07.05.2014{{
	бит_БухгалтерскиеОтчетыСервер.ЗаполнитьСписокВыбораВидаСравненияДляОрганизации(Элементы.ОрганизацияВидСравнения.СписокВыбора);
	// Изменение кода. Конец. 07.05.2014}}

	бит_ОтчетыСервер.УстановитьВидимостьПанелиНастроекПоУмолчаниюТакси(Элементы.ФормаКомандаПанельНастроек
														, Элементы.ГруппаПанельНастроек
														, фСкрытьПанельНастроек
														, фТаксиОткрытьПанельНастроек);
														
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если фОтказ Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
	мСоответствиеРезультатов = Новый Соответствие;
	 	
КонецПроцедуры // ПриОткрытии()

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ВариантМодифицирован = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Оповещение из хранилища настроек при сохранении.
	Если ИмяСобытия = ("СохраненаНастройка_" + фКлючОбъекта) Тогда
		
		ОбновитьПанельСохраненныхНастроек(Истина, Ложь, Параметр);
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаОповещения()

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
		
	// Видимость панели настроек
	бит_ОтчетыСервер.УстановитьВидимостьПанелиНастроек(Элементы.ФормаКомандаПанельНастроек
														, Элементы.ГруппаПанельНастроек
														, фСкрытьПанельНастроек
														, фТаксиОткрытьПанельНастроек);
	
	// Видимость панели сохраненных настроек
	Элементы.ФормаКомандаПанельСохраненныхНастроек.Пометка 	 = Не фСкрытьПанельСохраненныхНастроек;
	Элементы.ГруппаПанельВыбораСохраненныхНастроек.Видимость = Не фСкрытьПанельСохраненныхНастроек;
		
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_ДекорацияСохраненнойНастройкиНажатие(Элемент)
	
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
																	
КонецПроцедуры

&НаКлиенте
Процедура ПериодДатаНачалаПриИзменении(Элемент)
	
	ВремяКорректно = бит_ОбщегоНазначенияКлиентСервер.ВременнойИнтервалКорректный(Отчет.Период.ДатаНачала, 
																				Отчет.Период.ДатаОкончания);
																				
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальностьОтчета");	
	
КонецПроцедуры // ПериодДатаНачалаПриИзменении()

&НаКлиенте
Процедура ПериодДатаОкончанияПриИзменении(Элемент)
	
	ВремяКорректно = бит_ОбщегоНазначенияКлиентСервер.ВременнойИнтервалКорректный(Отчет.Период.ДатаНачала, 
																				 Отчет.Период.ДатаОкончания);
																				 
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальностьОтчета");
	
КонецПроцедуры // ПериодДатаОкончанияПриИзменении()

&НаКлиенте
Процедура СценарийПриИзменении(Элемент)
	
	Отчет.СценарийИспользование = Истина;
		
КонецПроцедуры // СценарийПриИзменении()

&НаКлиенте
Процедура СценарийВидСравненияПриИзменении(Элемент)
	
	Отчет.СценарийИспользование = Истина;
	УстановитьОтборПоСценарию(ПредВидСравненияСценарий);
	
КонецПроцедуры // СценарийВидСравненияПриИзменении()

&НаКлиенте
Процедура ОрганизацияВидСравненияПриИзменении(Элемент)
	
	Отчет.ОрганизацияИспользование = Истина;
	УстановитьОтборПоОрганизации(ПредВидСравненияОрганизация);
	
КонецПроцедуры // ОрганизацияВидСравненияПриИзменении()

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Отчет.ОрганизацияИспользование = Истина;
	// УстановитьОтборПоОрганизации();
	
КонецПроцедуры // ОрганизацияПриИзменении()

// Процедура - обработчик события "ПриИзменении" полей воода - простых параметров на форме.
// 
&НаКлиенте
Процедура ПростойПараметрПриИзменении(Элемент)
	
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальностьОтчета");
															
КонецПроцедуры // ПростойПараметрПриИзменении()

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	СуммаОтчета = бит_ОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(Результат);
	
КонецПроцедуры // РезультатПриАктивизацииОбласти()

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбраннаяРасшифровка = бит_БухгалтерскиеОтчетыКлиент.ПолучитьВыбраннуюРасшифровку(Расшифровка);
	
	Если ТипЗнч(ВыбраннаяРасшифровка) = Тип("Структура") Тогда

		// Общая расшифровка из левого верхнего угла.
		ОбщаяРасшифровка = Результат.Область(1, 1).Расшифровка;
		
		// Расшифровка колонки находится в заголовке колонки.
		РасшифровкаКолонки = Результат.Область(фВысотаЗаголовка + 2, Элемент.ТекущаяОбласть.Лево).Расшифровка;
				
		ВыбраннаяРасшифровка.Вставить("ВидОборота"         , РасшифровкаКолонки);
		ВыбраннаяРасшифровка.Вставить("ПоказыватьЗаголовок", фПоказыватьЗаголовок);
		
		// Открытие формы расшифровки
		бит_БухгалтерскиеОтчетыКлиент.ОбработкаРасшифровкиСтандартногоОтчета(Отчет, ЭтотОбъект, ВыбраннаяРасшифровка, ОбщаяРасшифровка);
	
	КонецЕсли;
	
КонецПроцедуры // РезультатОбработкаРасшифровки()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСубконто
    
&НаКлиенте
Процедура СубконтоПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = ?(Отчет.Субконто.Количество() >= фКэшЗначений.МаксКоличествоСубконто, Истина, Ложь);
		
КонецПроцедуры // СубконтоПередНачаломДобавления()

&НаКлиенте
Процедура СубконтоПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Копирование Тогда
	
		ТекущиеДанные = Элементы.Субконто.ТекущиеДанные;
		ТекущиеДанные.ВидСубконто = фКэшЗначений.ПустоеСубконто;
	
	КонецЕсли;
	
КонецПроцедуры // СубконтоПриНачалеРедактирования()

&НаКлиенте
Процедура СубконтоПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальностьОтчета");	
	
КонецПроцедуры // СубконтоПриОкончанииРедактирования()
   
&НаКлиенте
Процедура СубконтоВидСубконтоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Субконто.ТекущиеДанные;
	Ид = ?(ТекущиеДанные = Неопределено, Неопределено, ТекущиеДанные.ПолучитьИдентификатор());
	
	// ИзменениеВидаСубконтоСервер(Ид);
	
КонецПроцедуры // СубконтоВидСубконтоПриИзменении()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКорСубконто
 
&НаКлиенте
Процедура КорСубконтоПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = ?(Отчет.Субконто.Количество() >= фКэшЗначений.МаксКоличествоСубконто, Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КорСубконтоПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Копирование Тогда
	
		ТекущиеДанные = Элементы.Субконто.ТекущиеДанные;
		ТекущиеДанные.ВидСубконто = фКэшЗначений.ПустоеСубконто;
	
	КонецЕсли;
	
КонецПроцедуры // СубконтоПриНачалеРедактирования()

&НаКлиенте
Процедура КорСубконтоПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальностьОтчета");	
		
КонецПроцедуры // СубконтоПриОкончанииРедактирования()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСформировать(Команда)
	
	ОбновитьОтчет();
	
КонецПроцедуры // КомандаСформировать()

&НаКлиенте
Процедура КомандаПанельНастроек(Команда)
	
	ОбработкаКомандыПанелиНастроекСервер();
		
КонецПроцедуры // КомандаПанельНастроек()

&НаКлиенте
Процедура КомандаПанельСохраненныхНастроек(Команда)
	
	фСкрытьПанельСохраненныхНастроек = Не фСкрытьПанельСохраненныхНастроек;
	
	Элементы.ФормаКомандаПанельСохраненныхНастроек.Пометка   = Не фСкрытьПанельСохраненныхНастроек;
	Элементы.ГруппаПанельВыбораСохраненныхНастроек.Видимость = Не фСкрытьПанельСохраненныхНастроек;
	
КонецПроцедуры // КомандаПанельСохраненныхНастроек()

&НаКлиенте
Процедура КомандаОбновитьПанельСохраненныхНастроек(Команда)
	
	ОбновитьПанельСохраненныхНастроек(Истина);	
	
КонецПроцедуры // КомандаОбновитьПанельСохраненныхНастроек()

&НаКлиенте
Процедура КомандаНастроитьПериод(Команда)
	
	бит_РаботаСДиалогамиКлиент.ОткрытьДиалогСтандартногоПериода(Отчет);
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальностьОтчета");
	
КонецПроцедуры // КомандаНастроитьПериод()

&НаКлиенте
Процедура КомандаУстановитьСтандартныеНастройки(Команда)
	
	УстановитьСтандартныеНастройкиСервер();
		
КонецПроцедуры // КомандаУстановитьСтандартныеНастройки()
     
&НаКлиенте
Процедура Результат_ПоказатьВОтдельномОкне(Команда)
	
	бит_ОтчетыКлиент.ПоказатьКопиюРезультата(Результат);	
		
КонецПроцедуры // Результат_ПоказатьВОтдельномОкне()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет кэш значений, необходимый при работе на клиенте.
// 
&НаСервере
Процедура ЗаполнитьКэшЗначений()

	фКэшЗначений = Новый Структура;
	
	ИмяТипаОбъекта = СтрЗаменить(фПолноеИмяОтчета, "Отчет.", "ОтчетОбъект.");
	фКэшЗначений.Вставить("ИмяТипаОбъекта", ИмяТипаОбъекта);
	
	ОтчетОб = ДанныеФормыВЗначение(Отчет, Тип(ИмяТипаОбъекта));
	МетаданныеОбъекта = ОтчетОб.Метаданные();
	
	бит_БухгалтерскиеОтчетыСервер.ЗаполнитьПризнакиПоТипуОтчета(фКэшЗначений, ЭтотОбъект, МетаданныеОбъекта);
	бит_БухгалтерскиеОтчетыСервер.ЗаполнитьПризнакиПоМетаданным(фКэшЗначений, МетаданныеОбъекта);
	бит_БухгалтерскиеОтчетыСервер.ЗаполнитьПризнакиПоДаннымФормы(фКэшЗначений, ЭтотОбъект);
			                    		
	фКэшЗначений.Вставить("ТипНастройки"	   , Перечисления.бит_ТипыСохраненныхНастроек.Отчеты);
	фКэшЗначений.Вставить("НастраиваемыйОбъект", фПолноеИмяОтчета + "_Построитель");
	
	фКэшЗначений.Вставить("ВидСравненияРавно", ВидСравнения.Равно);
	
	СписокОбъектов = бит_РегламентныеЗакрытия.СформироватьСписокРегистровБухгалтерииДляВыбора();
	фКэшЗначений.Вставить("ДоступныеОбъектыСистемы", СписокОбъектов);
	
КонецПроцедуры // ЗаполнитьКэшЗначений()

// Процедура управляет видимостью и доступностью элементов формы.
// 
&НаСервере
Процедура УправлениеВидимостьюДоступностью()
	
	// Установка видимости и доступности элементов формы в зависимости от типа отчета 
	// - обычный или расшифровка. 
	бит_ОтчетыСервер.УстановитьВидимостьДоступностьЭлементов(Элементы 
															, Параметры.КлючВарианта 
															, Параметры.ПредставлениеВарианта
															, Ложь);
															
	// Изменение кода. Начало. 07.05.2014{{
	Если бит_МеханизмДопИзмерений.ЕстьДопИзмерениеОрганизация() Тогда
		Элементы.ГруппаОрганизация.Видимость = Истина;
	Иначе
		Элементы.ГруппаОрганизация.Видимость = Ложь;
	КонецЕсли;
	// Изменение кода. Конец. 07.05.2014}}
														
КонецПроцедуры // УправлениеВидимостьюДоступностью()

// Процедура - обработчик команды "КомандаПанельНастроек".
// 
// Параметры: 
//  СкрытьПанельПриФормировании - Булево (По умолчанию = Ложь).
//
&НаСервере
Процедура ОбработкаКомандыПанелиНастроекСервер(СкрытьПанельПриФормировании = Ложь)
	
	// Видимость панели настроек
	бит_ОтчетыСервер.ОбработкаКомандыПанелиНастроек(Элементы.ФормаКомандаПанельНастроек
													 , Элементы.ГруппаПанельНастроек
													 , фСкрытьПанельНастроек
													 , фТаксиОткрытьПанельНастроек
													 , СкрытьПанельПриФормировании);
	
КонецПроцедуры // ОбработкаКомандыПанелиНастроекСервер()

// Функция обновляет настройки отчета.
// 
// Параметры:
//  ИмяЭлемента  		 	  - Строка.
//  СоответствиеРезультатов   - Соответствие.
//  ТекущийРегистрБухгалтерии - РегистрБухгалтерииСсылка.* (По умолчанию = Неопределено).
// 
// ВозращаемоеЗначение:
//  Булево - настройки обновлены.
// 
&НаСервере
Функция ОбновитьНастройки(ИмяЭлемента, СоответствиеРезультатов, ТекущийРегистрБухгалтерии = Неопределено)
	
	НастройкиОбновлены = бит_БухгалтерскиеОтчетыСервер.ОбновитьНастройки(Отчет
																		, ЭтотОбъект
																		, ИмяЭлемента
																		, СоответствиеРезультатов
																		, ТекущийРегистрБухгалтерии);
																		
	ИзменениеСхемыКомпоновкиДанныхНаСервере();
	
	Возврат НастройкиОбновлены;

КонецФункции // ОбновитьНастройки()

// Процедура обновляет панель сохраненных настроек.
// 
// Параметры:
//  Очищать  		 		  - Булево (По умолчанию = Ложь).
//  ОчищатьНастройки 		  - Булево (По умолчанию = Ложь).
//  ТекКлючНастройки 		  - Строка (По умолчанию = Неопределено).
//  ТекущийРегистрБухгалтерии - РегистрБухгалтерииСсылка.* (По умолчанию = Неопределено).
// 
&НаСервере
Процедура ОбновитьПанельСохраненныхНастроек(ОчищатьПанельНастроек = Ложь, ОчищатьНастройки = Ложь
											, ТекКлючНастройки = Неопределено, ТекущийРегистрБухгалтерии = Неопределено)

	бит_БухгалтерскиеОтчетыСервер.ОбновитьПанельСохраненныхНастроекОтчета(Отчет
											, ЭтотОбъект
											, ОчищатьПанельНастроек
											, ОчищатьНастройки
											, ТекКлючНастройки
											, ТекущийРегистрБухгалтерии);
											
КонецПроцедуры // ОбновитьПанельСохраненныхНастроек()

// Процедура устанавливает стандартные настройки варианта 
// и обновляет по ним элементы формы.
// Заменяет типовую команду "СтандартныеНастройки".
// 
&НаСервере
Процедура УстановитьСтандартныеНастройкиСервер()
	
	бит_БухгалтерскиеОтчетыСервер.УстановитьЗначенияНастроекОтчетовПоУмолчанию(Отчет, ЭтотОбъект, фКэшЗначений.ИмяТипаОбъекта);
		
	бит_ОтчетыСервер.ВыделитьТекущуюСохраненнуюНастройку(Элементы, фСтруктураСохраненныхНастроек, фИмяЭлемента_ВыбраннаяНастройка);
														
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальностьОтчета");
	
КонецПроцедуры // УстановитьСтандартныеНастройкиСервер()          

// Обновляет результат отчета.
// 
// Параметры:
// 	Нет
// 
&НаСервере
Процедура ОбновитьОтчет() Экспорт

	СтрРегистрация = Новый Структура;
    бит_ук_СлужебныйСервер.РегистрацияНачалоСобытияВФорме(Ложь, СтрРегистрация, ЭтотОбъект.ИмяФормы);

	ОтчетОб = ДанныеФормыВЗначение(Отчет, Тип(фКэшЗначений.ИмяТипаОбъекта));
    // Синхронизация данных
	// бит_БухгалтерскиеОтчетыСервер.СинхронизироватьДанныеОтчета(Отчет, ОтчетОб, ЭтаФорма);
	
	ТаблицаСубконто = ДанныеФормыВЗначение(ГруппировкиСубконто, Тип("ТаблицаЗначений"));
	
	// Формирование результата	
	ОтчетСформирован = ОтчетОб.СформироватьОтчет(Результат, фПоказыватьЗаголовок, фВысотаЗаголовка, фТекстЗапроса, ТаблицаСубконто);
	ЗначениеВДанныеФормы(ОтчетОб, Отчет);
	
	Если ОтчетСформирован Тогда
		бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат);
	КонецЕсли;
	
	Если фСкрыватьНастройкиПриФормированииОтчета Тогда
		ОбработкаКомандыПанелиНастроекСервер(Истина);	
	КонецЕсли;
	
	бит_ук_СлужебныйСервер.РегистрацияФормированиеОтчета(Ложь, СтрРегистрация);

КонецПроцедуры // ОбновитьОтчет()

// Фиксирует изменения в СКД отчета.
// 
// Параметры:
// 	Нет
// 
&НаСервере
Процедура ИзменениеСхемыКомпоновкиДанныхНаСервере() Экспорт
	
	Схема = ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных);
		
	ИмяПоляПрефикс    = "Субконто";
	ИмяПоляПрефиксКор = "КорСубконто";
	
	// Изменение представления и наложения ограничения типа значения.
	Индекс = 1;
	Для Каждого Элем Из Отчет.Субконто Цикл
		Если ЗначениеЗаполнено(Элем.ВидСубконто) Тогда
			Поле = Схема.НаборыДанных.НаборДанныхОсновной.Поля.Найти(ИмяПоляПрефикс + Индекс);
			Если Поле <> Неопределено Тогда
				Поле.ТипЗначения = Элем.ВидСубконто.ТипЗначения;
				Поле.Заголовок   = Строка(Элем.ВидСубконто);
			КонецЕсли;
			Индекс = Индекс + 1;
		КонецЕсли;
	КонецЦикла;
	
	Индекс = 1;
	Для Каждого Элем Из Отчет.КорСубконто Цикл
		Если ЗначениеЗаполнено(Элем.ВидСубконто) Тогда
			Поле = Схема.НаборыДанных.НаборДанныхОсновной.Поля.Найти(ИмяПоляПрефиксКор + Индекс);
			Если Поле <> Неопределено Тогда
				Поле.ТипЗначения = Элем.ВидСубконто.ТипЗначения;
				Поле.Заголовок   = "Кор. " + Строка(Элем.ВидСубконто);
			КонецЕсли;
			Индекс = Индекс + 1;
		КонецЕсли;
	КонецЦикла;
		
	СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(Схема, СхемаКомпоновкиДанных);
	Отчет.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
		
КонецПроцедуры

&НаСервере
Функция ПолучитьЗапрещенныеПоля()
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	СписокПолей.Добавить("Показатели");
	СписокПолей.Добавить("Организация");
	СписокПолей.Добавить("Сценарий");

	КоличествоСубконто = 0;
	Для Каждого ЭлементСписка Из Отчет.Субконто Цикл
		Если ЗначениеЗаполнено(ЭлементСписка.ВидСубконто) Тогда
			КоличествоСубконто = КоличествоСубконто + 1;
		КонецЕсли;
	КонецЦикла;
	
	Для Индекс = КоличествоСубконто + 1 По фКэшЗначений.МаксКоличествоСубконто Цикл
		СписокПолей.Добавить("Субконто" + Индекс);
	КонецЦикла;
	
	КоличествоКорСубконто = 0;
	Для Каждого ЭлементСписка Из Отчет.КорСубконто Цикл
		Если ЗначениеЗаполнено(ЭлементСписка.ВидСубконто) Тогда
			КоличествоКорСубконто = КоличествоКорСубконто + 1;
		КонецЕсли;
	КонецЦикла;
	
	Для Индекс = КоличествоКорСубконто + 1 По фКэшЗначений.МаксКоличествоСубконто Цикл
		СписокПолей.Добавить("КорСубконто" + Индекс);
	КонецЦикла;
	
	Если Не Отчет.ПоВалютам Тогда
		СписокПолей.Добавить("Валюта");
		СписокПолей.Добавить("ВалютаКор");
	КонецЕсли;

	ДобавитьПоляРесурсов(СписокПолей, "Сценарий");
	ДобавитьПоляРесурсов(СписокПолей, "Регл");
	ДобавитьПоляРесурсов(СписокПолей, "Упр");
	
	СписокПолей.Добавить("ЕстьКоличественныеСчета");
	СписокПолей.Добавить("ЕстьВалютныеСчета");

	Возврат Новый ФиксированныйМассив(СписокПолей);	
	
КонецФункции

// Процедура 
// 
// Параметры:
//  Параметр1 - Строка.
// 
&НаСервере
Процедура ДобавитьПоляРесурсов(СписокПолей, ВидРесурса)
	
	СписокПолей.Добавить("Сумма"+ВидРесурса+"ОборотДт");
	СписокПолей.Добавить("Сумма"+ВидРесурса+"ОборотКт");

КонецПроцедуры // ДобавитьПоляРесурсов()

&НаСервере
Процедура КомандаТестНаСервере()
	
	Схема = Новый СхемаЗапроса;
	
	Пакет = Схема.ПакетЗапросов[0];
	Оператор = Пакет.Операторы[0];
	
	// Источник
	ИсточникОбороты = Оператор.Источники.Добавить(Схема.ПакетЗапросов[0].ДоступныеТаблицы.Найти("РегистрБухгалтерии.бит_Бюджетирование.Обороты"));
	ИсточникОбороты.Источник.Псевдоним = "ОборотыБюдж";
	
	// Поля
	МассивПолей = Новый Массив;	
	МассивПолей.Добавить("Счет");
	МассивПолей.Добавить("Субконто1");
	МассивПолей.Добавить("Субконто2");
	МассивПолей.Добавить("Субконто3");
	МассивПолей.Добавить("Субконто4");
	МассивПолей.Добавить("КорСчет");
	МассивПолей.Добавить("КорСубконто1");
	МассивПолей.Добавить("КорСубконто2");
	МассивПолей.Добавить("КорСубконто3");
	МассивПолей.Добавить("КорСубконто4");
	МассивПолей.Добавить("Сценарий");
	МассивПолей.Добавить("ЦФО,");
	МассивПолей.Добавить("Валюта,");
	МассивПолей.Добавить("ВалютаКор,");
	МассивПолей.Добавить("Организация,");
	МассивПолей.Добавить("СуммаРеглОборот");
	МассивПолей.Добавить("СуммаРеглОборотДт");
	МассивПолей.Добавить("СуммаРеглОборотКт");
	МассивПолей.Добавить("СуммаУпрОборот");
	МассивПолей.Добавить("СуммаУпрОборотДт");
	МассивПолей.Добавить("СуммаУпрОборотКт");
	МассивПолей.Добавить("СуммаСценарийОборот");
	МассивПолей.Добавить("СуммаСценарийОборотДт");
	МассивПолей.Добавить("СуммаСценарийОборотКт");
	МассивПолей.Добавить("ВалютнаяСуммаОборот");
	МассивПолей.Добавить("ВалютнаяСуммаОборотДт");
	МассивПолей.Добавить("ВалютнаяСуммаОборотКт");
	МассивПолей.Добавить("ВалютнаяСуммаКорОборот");
	МассивПолей.Добавить("ВалютнаяСуммаКорОборотДт");
	МассивПолей.Добавить("ВалютнаяСуммаКорОборотКт");
	МассивПолей.Добавить("КоличествоОборот");
	МассивПолей.Добавить("КоличествоОборотДт");
	МассивПолей.Добавить("КоличествоОборотКт");
	МассивПолей.Добавить("КоличествоКорОборот");
	МассивПолей.Добавить("КоличествоКорОборотДт");
	МассивПолей.Добавить("КоличествоКорОборотКт");

	Для каждого ДоступноеПоле Из ИсточникОбороты.Источник.ДоступныеПоля Цикл
	
		Если НЕ МассивПолей.Найти(ДоступноеПоле.Имя) = Неопределено Тогда
		
			 Оператор.ВыбираемыеПоля.Добавить(ДоступноеПоле);
		
		КонецЕсли; 
	
	КонецЦикла; 
	
	ИсточникОбороты.Источник.Параметры[4].Выражение = Новый ВыражениеСхемыЗапроса("&СписокВидовСубконто");
    ИсточникОбороты.Источник.Параметры[7].Выражение = Новый ВыражениеСхемыЗапроса("&СписокКорВидовСубконто");
	
	ТекстЗапроса = Схема.ПолучитьТекстЗапроса();
	
	бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстЗапроса);
	
КонецПроцедуры


// Устанавливает отбор по сценарию в таблицу отборов.
// 
&НаСервере
Процедура УстановитьОтборПоСценарию(ВидСравненияСценарий = Неопределено)
	
	бит_БухгалтерскиеОтчетыСервер.УстановитьОтборПоСценарию(Отчет, ЭтотОбъект, ВидСравненияСценарий);
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(ЭтотОбъект.Элементы.Результат, "НеАктуальностьОтчета");
		
КонецПроцедуры // УстановитьОтборПоСценарию()

// устанавливает отбор по организации в таблицу отборов.
// 
// Параметры:
// 	Нет
// 
&НаСервере
Процедура УстановитьОтборПоОрганизации(ВидСравненияОрганизация = Неопределено)
	
	бит_БухгалтерскиеОтчетыСервер.УстановитьОтборПоОрганизации(Отчет, ЭтотОбъект, ВидСравненияОрганизация);
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(ЭтотОбъект.Элементы.Результат, "НеАктуальностьОтчета");
		
КонецПроцедуры // УстановитьОтборПоОрганизации()

&НаКлиенте
Процедура КомандаТест(Команда)
	
	КомандаТестНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьОтчет(Команда)
	
	ОбновитьОтчет();
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрБухгалтерииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокВидовОбъектов = Новый СписокЗначений;
	СписокВидовОбъектов.Добавить(ПредопределенноеЗначение("Перечисление.бит_ВидыОбъектовСистемы.РегистрБухгалтерии"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидыОбъектов"           ,СписокВидовОбъектов);
	ПараметрыФормы.Вставить("ТекущийОбъектСистемы"   ,Отчет.РегистрБухгалтерии);
	ПараметрыФормы.Вставить("ДоступныеОбъектыСистемы",фКэшЗначений.ДоступныеОбъектыСистемы);
	ОткрытьФорму("ОбщаяФорма.бит_ФормаВыбораОбъектовСистемыУправляемая",ПараметрыФормы,Элемент,УникальныйИдентификатор);	

КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиОтборПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ИзменениеСхемыКомпоновкиДанныхНаСервере();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", ЭтотОбъект.СхемаКомпоновкиДанных);
	ПараметрыФормы.Вставить("Режим"                , "Отбор");
	ПараметрыФормы.Вставить("ИсключенныеПоля"      , ПолучитьЗапрещенныеПоля());
	ПараметрыФормы.Вставить("ТекущаяСтрока"        , Неопределено);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", ЭтотОбъект);
	ДополнительныеПараметры.Вставить("Элемент", Элемент);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОтборыПередНачаломДобавленияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы,,,,,ОповещениеОЗакрытии);
	
	Отказ = Истина;	

КонецПроцедуры

&НаКлиенте
// Обработка оповещения закрытия формы выбора полей отбора.
// 
// Параметры:
// РезультатЗакрытия - Структура.
// 
Процедура ОтборыПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Форма =   ДополнительныеПараметры.Форма;
	Элемент = ДополнительныеПараметры.Элемент;
	
	ПараметрыВыбранногоПоля = РезультатЗакрытия;
	
	Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
		
		Если Элемент.ТекущаяСтрока = Неопределено Тогда
			ТекущаяСтрока = Неопределено;
		Иначе
			ТекущаяСтрока = Форма.Отчет.КомпоновщикНастроек.Настройки.Отбор.ПолучитьОбъектПоИдентификатору(Элемент.ТекущаяСтрока);
		КонецЕсли;

		Если ТипЗнч(ТекущаяСтрока) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			ЭлементОтбора = ТекущаяСтрока.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ИначеЕсли ТипЗнч(ТекущаяСтрока) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Если ТекущаяСтрока.Родитель <> Неопределено Тогда
				ЭлементОтбора = ТекущаяСтрока.Родитель.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			Иначе
				ЭлементОтбора = Форма.Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			КонецЕсли;
		Иначе
			ЭлементОтбора = Форма.Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		КонецЕсли;
		
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ПараметрыВыбранногоПоля.Поле);
		Если Строка(ПараметрыВыбранногоПоля.Поле) = "Организация"
			И Форма.Отчет.Свойство("Организация") Тогда
			ЭлементОтбора.ПравоеЗначение = Форма.Отчет.Организация;
		ИначеЕсли Строка(ПараметрыВыбранногоПоля.Поле) = "Подразделение"
			И Форма.Отчет.Свойство("Подразделение") Тогда 
			ЭлементОтбора.ПравоеЗначение = Форма.Отчет.Подразделение;
		КонецЕсли;
		ЭлементОтбора.ВидСравнения = ПараметрыВыбранногоПоля.ВидСравнения;
		
		Элемент.ТекущаяСтрока = Форма.Отчет.КомпоновщикНастроек.Настройки.Отбор.ПолучитьИдентификаторПоОбъекту(ЭлементОтбора);
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура СубконтоПриИзменении(Элемент)
	
	ИзменениеСхемыКомпоновкиДанныхНаСервере();

	ИзменениеГруппировкиСубконто();
	
КонецПроцедуры


&НаКлиенте
Процедура КорСубконтоПриИзменении(Элемент)
	
	ИзменениеСхемыКомпоновкиДанныхНаСервере();

	ИзменениеГруппировкиСубконто();
	
КонецПроцедуры


&НаКлиенте
Процедура СценарийВидСравненияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	ПредВидСравненияСценарий = Отчет.СценарийВидСравнения;

КонецПроцедуры


&НаКлиенте
Процедура ОрганизацияВидСравненияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПредВидСравненияОрганизация = Отчет.ОрганизацияВидСравнения;
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиОтборЛевоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИзменениеСхемыКомпоновкиДанныхНаСервере();

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", ЭтотОбъект.СхемаКомпоновкиДанных);
	ПараметрыФормы.Вставить("Режим"                , "Отбор");
	ПараметрыФормы.Вставить("ИсключенныеПоля"      , ПолучитьЗапрещенныеПоля());
	ПараметрыФормы.Вставить("ТекущаяСтрока"        , Неопределено);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма",         ЭтотОбъект);
	ДополнительныеПараметры.Вставить("Элемент",       Элемент);
	ДополнительныеПараметры.Вставить("ТекущаяСтрока", Элементы.КомпоновщикНастроекНастройкиОтбор.ТекущаяСтрока);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОтборыЛевоеЗначениеНачалоВыбораяЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы,,,,, ОповещениеОЗакрытии);
	
	СтандартнаяОбработка = Ложь;	
	
КонецПроцедуры

&НаКлиенте
// Обработка оповещения закрытия формы выбора полей отбора.
// 
// Параметры:
// РезультатЗакрытия - Структура.
// 
Процедура ОтборыЛевоеЗначениеНачалоВыбораяЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Форма =   ДополнительныеПараметры.Форма;
	Элемент = ДополнительныеПараметры.Элемент;
	
	ПараметрыВыбранногоПоля = РезультатЗакрытия;
	
	Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
		
		ТекущаяСтрока = Форма.Отчет.КомпоновщикНастроек.Настройки.Отбор.ПолучитьОбъектПоИдентификатору(ДополнительныеПараметры.ТекущаяСтрока);
        ТекущаяСтрока.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПараметрыВыбранногоПоля.Поле);
				
	КонецЕсли;
	
КонецПроцедуры

// Процедура фиксирует изменение группировок. 
// 
// Параметры:
//  Нет.
// 
&НаСервере
Процедура ИзменениеГруппировкиСубконто()

	ГруппировкиСубконто.Очистить();
	
	Для Инд = 1 По Отчет.Субконто.Количество() Цикл
		НоваяСтрока = ГруппировкиСубконто.Добавить();
		НоваяСтрока.Субконто = Отчет.Субконто[Инд-1].ВидСубконто;
		НоваяСтрока.Использовать = Истина;
		НоваяСтрока.ИмяСубконто  = "Субконто" + Инд;
	КонецЦикла;
	
	Для Инд = 1 По Отчет.КорСубконто.Количество() Цикл
		НоваяСтрока = ГруппировкиСубконто.Добавить();
		НоваяСтрока.Субконто = Отчет.КорСубконто[Инд-1].ВидСубконто;
		НоваяСтрока.Использовать = Истина;
		НоваяСтрока.ИмяСубконто  = "КорСубконто" + Инд;
	КонецЦикла;

КонецПроцедуры // ИзменениеГруппировкиСубконто()	

#Область ПроцедурыИФункцииПоРаботеСНастройками

// Функция создает структуру, хранящую настройки.
// 
// Возвращаемое значение:
//   СтруктураНастроек - Структура.
// 
&НаСервере
Функция УпаковатьНастройкиВСтруктуру()

	СтруктураНастроек = бит_БухгалтерскиеОтчетыСервер.УпаковатьНастройкиОтчетаВСтруктуру(Отчет, ЭтотОбъект);
	Возврат СтруктураНастроек;
	
КонецФункции // УпаковатьНастройкиВСтруктуру()

// Процедура применяет сохраненну настройки.
// 
// Параметры:
//  ВыбНастройка  			  - СправочникСсылка.бит_СохраненныеНастройки.
//  ТекущийРегистрБухгалтерии - РегистрыБухгалтерииСсылка.
//  ВыделитьТекущуюНастройку  - Булево (По умолчанию = Ложь).
// 
&НаСервере
Процедура ПрименитьНастройки(ВыбНастройка, ТекущийРегистрБухгалтерии = Неопределено, ВыделитьТекущуюНастройку = Ложь)
	
	бит_БухгалтерскиеОтчетыСервер.ПрименитьНастройкиОтчета(Отчет, ЭтотОбъект, ВыбНастройка, ТекущийРегистрБухгалтерии);
	
	Если ВыделитьТекущуюНастройку Тогда 		
		бит_ОтчетыСервер.ВыделитьТекущуюСохраненнуюНастройку(Элементы, 
															фСтруктураСохраненныхНастроек, 
															фИмяЭлемента_ВыбраннаяНастройка,
															,
															ВыбНастройка.КлючНастройки);
	КонецЕсли;
		
КонецПроцедуры // ПрименитьНастройки()

// Процедура - обработчик события "Нажатие" кнопки "НастройкиСохранить" 
// коммандной панели "ДействияФормы".
// 
&НаКлиенте
Процедура ДействияФормыНастройкиСохранить(Кнопка)
	
	ПараметрыФормы     = Новый Структура;
	СтруктураНастройки = УпаковатьНастройкиВСтруктуру();
	ПараметрыФормы.Вставить("СтруктураНастройки" , СтруктураНастройки);
	ПараметрыФормы.Вставить("ТипНастройки"		 , фКэшЗначений.ТипНастройки);
	ПараметрыФормы.Вставить("НастраиваемыйОбъект", фКэшЗначений.НастраиваемыйОбъект);
	
	ОткрытьФорму("ХранилищеНастроек.бит_ХранилищеНастроек.ФормаСохранения",
											ПараметрыФормы,
											ЭтотОбъект);	
													
КонецПроцедуры // ДействияФормыНастройкиСохранить()

// Процедура - обработчик события "Нажатие" кнопки "НастройкиВосстановить" 
// коммандной панели "ДействияФормы".
// 
&НаКлиенте
Процедура ДействияФормыНастройкиВосстановить(Кнопка)
	
	ПараметрыФормы     = Новый Структура;
	ПараметрыФормы.Вставить("ТипНастройки"		 , фКэшЗначений.ТипНастройки);
	ПараметрыФормы.Вставить("НастраиваемыйОбъект", фКэшЗначений.НастраиваемыйОбъект);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ЗакрытиеДействияФормыНастройкиВосстановить", ЭтотОбъект);
	
	ОткрытьФорму("ХранилищеНастроек.бит_ХранилищеНастроек.ФормаЗагрузки",
											ПараметрыФормы,
											ЭтотОбъект,,,,ОповещениеОЗакрытии);
	
			
КонецПроцедуры // ДействияФормыНастройкиВосстановить()

// Обработка оповещения о закрытии формы. 
// 
// Параметры:
//  ВыбНастройка - НастройкаОтчета.
// 
&НаКлиенте
Процедура ЗакрытиеДействияФормыНастройкиВосстановить(ВыбНастройка, ДопПараметры) Экспорт

	Если ЗначениеЗаполнено(ВыбНастройка) Тогда		
		ПрименитьНастройки(ВыбНастройка, , Истина);		
	КонецЕсли;

КонецПроцедуры // ЗакрытиеДействияФормыНастройкиВосстановить()

#КонецОбласти

#КонецОбласти


