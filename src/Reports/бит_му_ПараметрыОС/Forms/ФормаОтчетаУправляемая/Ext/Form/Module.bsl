﻿	
#Область ОписаниеПеременных

&НаКлиенте
Перем мСоответствиеРезультатов; // Хранит соответствие результатов формирования отчета.

#КонецОбласти

#Область ОбработчикиСобытийФормы
	
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Отчет);
	
	фПолноеИмяОтчета = бит_ОбщегоНазначения.ПолучитьИмяОбъектаПоИмениФормы(ЭтаФорма.ИмяФормы, Истина);
			
	// Вызов механизма защиты
	
	
	фЗагружатьНастройки   = Истина;
	
	РежимФормирования = бит_ОтчетыСервер.РежимыОтчетов(фПолноеИмяОтчета);
	
	УправлениеВидимостьюДоступностью();
	
	ОбновитьПанельСохраненныхНастроек();
	
	фСформироватьПриОткрытии = Параметры.СформироватьПриОткрытии;
	Параметры.СформироватьПриОткрытии = Ложь;		
	
	бит_ОтчетыСервер.УстановитьВидимостьПанелиНастроекПоУмолчаниюТакси(Элементы.ФормаКомандаПанельНастроек
														, Элементы.ГруппаПанельНастроек
														, фСкрытьПанельНастроек
														, фТаксиОткрытьПанельНастроек);
														
КонецПроцедуры // ПриСозданииНаСервере()

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
	
	// Фильтр сохраненных настроек по варианту
	Элементы.КомандаФильтроватьНастройкиПоВариантам.Пометка = фФильтроватьНастройкиПоВарианту;
	ИзменитьФильтрНастроек(фФильтроватьНастройкиПоВарианту);
	
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

&НаСервере
Процедура ПриСохраненииВариантаНаСервере(Настройки)
	
	Если фКлючТекущегоВарианта <> КлючТекущегоВарианта Тогда
		УстановитьТекущийВариант(КлючТекущегоВарианта); 		
	КонецЕсли;                                       
		
КонецПроцедуры // ПриСохраненииВариантаНаСервере()

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	фКлючТекущегоВарианта = КлючТекущегоВарианта;
		
	КлючОбъекта = ?(ЗначениеЗаполнено(КлючТекущегоВарианта), 
					фПолноеИмяОтчета + "/" + КлючТекущегоВарианта, 
					фПолноеИмяОтчета);
		
	бит_ОтчетыСервер.ИзменитьВидимостьСохраненныхНастроек(Элементы, фСтруктураСохраненныхНастроек, КлючОбъекта, фФильтроватьНастройкиПоВарианту, Истина);
	
	Если фЗагружатьНастройки Тогда
		
		// Установка настройки, используемой при открытии, если такая указана в справочнике.
		КлючНастройкиПоУмолчанию = бит_ОтчетыСервер.НайтиНастройкуПоУмолчаниюДляОбъекта(КлючОбъекта, Истина);
		
		Если ЗначениеЗаполнено(КлючНастройкиПоУмолчанию) Тогда
			УстановитьТекущиеПользовательскиеНастройки(КлючНастройкиПоУмолчанию);
		Иначе
			УстановитьСтандартныеНастройкиСервер(Истина);
			фИмяЭлемента_ВыбраннаяНастройка = "";
		КонецЕсли;
		
		Результат.Очистить();
	
	КонецЕсли;
			
КонецПроцедуры // ПриЗагрузкеВариантаНаСервере()

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	Для каждого ЭлементСписка Из фСписокПараметровНаФорме Цикл
		
		ИмяПараметра = ЭлементСписка.Значение;
		бит_ОтчетыСервер.УстановитьЗначениеПараметраКомпоновщика(Отчет.КомпоновщикНастроек, 
																 Отчет[ИмяПараметра], 
																 ИмяПараметра);
		
	КонецЦикла; 
	
КонецПроцедуры // ПриСохраненииПользовательскихНастроекНаСервере()
 
&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	Если Настройки = Неопределено ИЛИ Не фЗагружатьНастройки Тогда 
		Возврат;
	КонецЕсли;
	          	
	бит_ОтчетыСервер.ЗаполнитьПараметрыНаФормеИзНастроек(Отчет, Настройки, фСписокПараметровНаФорме);
                                      		
	Если Настройки.ДополнительныеСвойства.Свойство("КлючНастройки") Тогда
		ТекКлючНастройки = Настройки.ДополнительныеСвойства.КлючНастройки;
		бит_ОтчетыСервер.ВыделитьТекущуюСохраненнуюНастройку(Элементы, 
															фСтруктураСохраненныхНастроек, 
															фИмяЭлемента_ВыбраннаяНастройка,
															фФильтроватьНастройкиПоВарианту,
															ТекКлючНастройки);
	КонецЕсли;
		
КонецПроцедуры // ПриЗагрузкеПользовательскихНастроекНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если фОтказ Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	
	Если фСформироватьПриОткрытии Тогда
		бит_ОтчетыКлиент.СформироватьОтчет(ЭтаФорма, Элементы.ГруппаКоманднаяПанельОтчетаЛевая, РежимФормирования.Расшифровки);
	КонецЕсли;		
	
	мСоответствиеРезультатов = Новый Соответствие;
	 	
КонецПроцедуры // ПриОткрытии()

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Оповещение из хранилища настроек при сохранении.
	Если ИмяСобытия = ("СохраненаНастройка_" + фПолноеИмяОтчета) Тогда
		
		ОбновитьПанельСохраненныхНастроек(Истина, Параметр);
		
	// Оповещение из формы настрек при закрытии
	ИначеЕсли ИмяСобытия = ("ИзмененыНастройки_" + фПолноеИмяОтчета) Тогда
		
		СтруктураПараметров = Параметр;
		
		ЗагрузитьНастройкиИзСтруктуры(СтруктураПараметров);
						
	КонецЕсли;
	
КонецПроцедуры // ОбработкаОповещения()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события "Нажатие" элемента формы "ДекорацияНастройки<№>".
// 
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

// Процедура - обработчик события "ПриАктивизацииОбласти" поля табличного документа "Результат".
// 
&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	СуммаОтчета = бит_ОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(Результат);
	
КонецПроцедуры // РезультатПриАктивизацииОбласти()

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - действие команды "Сформировать".
// Выполняется формирование отчета.
// 
&НаКлиенте
Процедура КомандаСформировать(Команда)
	
	бит_ОтчетыКлиент.СформироватьОтчет(ЭтаФорма, Элементы.ГруппаКоманднаяПанельОтчетаЛевая, РежимФормирования.Отчеты);
	
КонецПроцедуры // КомандаСформировать()

// Процедура - обработчик команды "КомандаФильтроватьНастройкиПоВариантам".
// 
&НаКлиенте
Процедура КомандаФильтроватьНастройкиПоВариантам(Команда)
	
	фФильтроватьНастройкиПоВарианту = Не фФильтроватьНастройкиПоВарианту;
	
	Элементы.КомандаФильтроватьНастройкиПоВариантам.Пометка = фФильтроватьНастройкиПоВарианту;
	ИзменитьФильтрНастроек(фФильтроватьНастройкиПоВарианту);
	
КонецПроцедуры // КомандаФильтроватьНастройкиПоВариантам()

// Процедура - обработчик команды "КомандаПанельНастроек".
// 
&НаКлиенте
Процедура КомандаПанельНастроек(Команда)
	
	ОбработкаКомандыПанелиНастроекСервер();	
	
КонецПроцедуры // КомандаПанельНастроек()

// Процедура - обработчик команды "КомандаПанельСохраненныхНастроек".
// 
&НаКлиенте
Процедура КомандаПанельСохраненныхНастроек(Команда)
	
	фСкрытьПанельСохраненныхНастроек = Не фСкрытьПанельСохраненныхНастроек;
	
	Элементы.ФормаКомандаПанельСохраненныхНастроек.Пометка   = Не фСкрытьПанельСохраненныхНастроек;
	Элементы.ГруппаПанельВыбораСохраненныхНастроек.Видимость = Не фСкрытьПанельСохраненныхНастроек;
	
КонецПроцедуры // КомандаПанельСохраненныхНастроек()

// Процедура - обработчик команды "КомандаПанельСохраненныхНастроек".
// 
&НаКлиенте
Процедура КомандаОбновитьПанельСохраненныхНастроек(Команда)
	
	ОбновитьПанельСохраненныхНастроек(Истина);	
	
КонецПроцедуры // КомандаОбновитьПанельСохраненныхНастроек()

// Процедура - обработчик команды "КомандаУстановитьСтандартныеНастройки".
// 
&НаКлиенте
Процедура КомандаУстановитьСтандартныеНастройки(Команда)
	
	УстановитьСтандартныеНастройкиСервер();
	
КонецПроцедуры // КомандаУстановитьСтандартныеНастройки()
     
// Процедура - обработчик команды "Результат_ПоказатьВОтдельномОкне".
// 
&НаКлиенте
Процедура Результат_ПоказатьВОтдельномОкне(Команда)
	
	бит_ОтчетыКлиент.ПоказатьКопиюРезультата(Результат);	
		
КонецПроцедуры // Результат_ПоказатьВОтдельномОкне()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура управляет видимостью и доступностью элементов формы.
// 
&НаСервере
Процедура УправлениеВидимостьюДоступностью()
	
	// Установка видимости и доступности элементов формы в зависимости от типа отчета 
	// - обычный или расшифровка.
	бит_ОтчетыСервер.УстановитьВидимостьДоступностьЭлементов(Элементы, 
															Параметры.КлючВарианта, 
															Параметры.ПредставлениеВарианта);
		          	
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

// Процедура включает/отключает фильтр настроек по варианту.
// 
// Параметры:
//  Фильтровать  - Булево.
// 
&НаСервере
Процедура ИзменитьФильтрНастроек(Фильтровать)

	КлючОбъекта = ?(ЗначениеЗаполнено(КлючТекущегоВарианта), 
					фПолноеИмяОтчета + "/" + КлючТекущегоВарианта, 
					фПолноеИмяОтчета);
	бит_ОтчетыСервер.ИзменитьВидимостьСохраненныхНастроек(Элементы, фСтруктураСохраненныхНастроек, КлючОбъекта, фФильтроватьНастройкиПоВарианту);	

КонецПроцедуры // ИзменитьФильтрНастроек()

// Функция обновляет настройки отчета.
// 
// Параметры:
//  ИмяЭлемента  		 	- Строка.
//  СоответствиеРезультатов - Соответствие.
// 
// ВозращаемоеЗначение:
//  Булево - настройки обновлены.
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
	
	// Выведем результат, если он уже формировался для текущей настройки.
	Если НастройкиОбновлены Тогда		
		СтруктураРез = СоответствиеРезультатов.Получить(КлючНастройки);
		Если СтруктураРез <> Неопределено Тогда
			Результат.Вывести(СтруктураРез.Результат);
			ДанныеРасшифровки = СтруктураРез.ДанныеРасшифровки;
		КонецЕсли; 		
	КонецЕсли;
	       	
	Возврат НастройкиОбновлены;

КонецФункции // ОбновитьНастройки()

// Процедура обновляет панель сохраненных настроек.
// 
// Параметры:
//  Очищать  - Булево (Необязательный, по умолчанию = Ложь).
//  ТекКлючНастройки  (Необязательный).
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
	
	КлючОбъекта = фПолноеИмяОтчета + "/" + КлючТекущегоВарианта;
				
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

// Процедура устанавливает стандартные настройки варианта 
// и обновляет по ним элементы формы.
// Заменяет типовую команду "СтандартныеНастройки".
// 
&НаСервере
Процедура УстановитьСтандартныеНастройкиСервер(ВосстанавливатьНастройки = Ложь)
	
	бит_ОтчетыСервер.УстановитьСтандартныеНастройкиСервер(Отчет, ВосстанавливатьНастройки, фСписокПараметровНаФорме);
	
	бит_ОтчетыСервер.ВыделитьТекущуюСохраненнуюНастройку(Элементы, 
														фСтруктураСохраненныхНастроек, 
														фИмяЭлемента_ВыбраннаяНастройка,
														фФильтроватьНастройкиПоВарианту);
															
КонецПроцедуры // УстановитьСтандартныеНастройкиСервер()          

// Процедура загружает пользовательские настройки компоновщика.
// 
// Параметры:
//  СтруктураПараметров  - Структура.
// 
&НаСервере
Процедура ЗагрузитьНастройкиИзСтруктуры(СтруктураПараметров)

	Отчет.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(СтруктураПараметров.ПользовательскиеНастройки);
		
КонецПроцедуры // ЗагрузитьНастройкиИзСтруктуры()

#КонецОбласти
