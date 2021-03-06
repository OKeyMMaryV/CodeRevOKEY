	
#Область ОписаниеПеременных

&НаКлиенте
Перем мСоответствиеРезультатов; // Хранит соответствие результатов формирования отчета.

&НаКлиенте
Перем мТекущийВидСравнения; // Служит для передачи вида сравнения между обработчиками.

&НаКлиенте
Перем мТекущийВидСравненияПоОрганизации; // Служит для передачи вида сравнения между обработчиками.

&НаКлиенте
Перем мТекущийРегистрБухгалтерии; // Хранит текущий регистр бухгалтерии.

#КонецОбласти

#Область ОбработчикиСобытийФормы
	
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Отчет);
	
	фПолноеИмяОтчета = бит_ОбщегоНазначения.ПолучитьИмяОбъектаПоИмениФормы(ЭтаФорма.ИмяФормы, Истина);
	фКлючОбъекта = фПолноеИмяОтчета + "_Построитель";
			
	// Вызов механизма защиты
	
	
	ЗаполнитьКэшЗначений();      	
	
	// Если это обработка расшифровки 
	Если Параметры.ЭтоОбработкаРасшифровки Тогда
		
		бит_БухгалтерскиеОтчетыСервер.ЗаполнитьОтчетПоПараметрамРасшифровки(Отчет, ЭтаФорма, Параметры.Расшифровка);
				
	Иначе
		
		Если Параметры.Свойство("РФ_РегистрБухгалтерии") Тогда
			Отчет.РегистрБухгалтерии = Параметры.РФ_РегистрБухгалтерии; 
			ИзменениеРегистраБухгалтерииСервер();
		КонецЕсли;
		ОбновитьПанельСохраненныхНастроек(, Истина);
	
	КонецЕсли;
	
	УправлениеВидимостьюДоступностью();
	
	// Оформление таблицы отборов
	бит_МеханизмПолученияДанных.УстановитьОформлениеТаблицыОтбор(УсловноеОформление);
	
	// Формирование отчета при открытии, если требуется.
	Если Параметры.СформироватьПриОткрытии = Истина Тогда
		ОбновитьОтчет();
		Параметры.СформироватьПриОткрытии = Ложь;
	КонецЕсли;   
	
	бит_БухгалтерскиеОтчетыСервер.ЗаполнитьСписокВыбораВидаСравненияДляОрганизации(Элементы.ОрганизацияВидСравнения.СписокВыбора);
	УстановитьЗаголовокПоляОрганизации();
	
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
		
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если фОтказ Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
	мСоответствиеРезультатов 		  = Новый Соответствие;
	мТекущийРегистрБухгалтерии 		  = Отчет.РегистрБухгалтерии;
	мТекущийВидСравненияПоОрганизации = Отчет.ОрганизацияВидСравнения;
	 	
КонецПроцедуры // ПриОткрытии()

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Оповещение из хранилища настроек при сохранении.
	Если ИмяСобытия = ("СохраненаНастройка_" + фКлючОбъекта) Тогда
		
		ОбновитьПанельСохраненныхНастроек(Истина, Ложь, Параметр, мТекущийРегистрБухгалтерии);
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаОповещения()

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
	НастройкиОбновлены = ОбновитьНастройки(ИмяЭлемента, мСоответствиеРезультатов, мТекущийРегистрБухгалтерии);
	Если Не НастройкиОбновлены Тогда
		ТекстСообщения = Нстр("ru = 'Настройка не найдена. Обновите панель сохраненных настроек.'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения); 	
	КонецЕсли;
	
	бит_ОтчетыКлиент.ОбработатьНажатиеНаПолеСохраненнойНастройки(Элементы, 
																Элемент, 
																фИмяЭлемента_ВыбраннаяНастройка);
																
	мТекущийРегистрБухгалтерии 		  = Отчет.РегистрБухгалтерии;
	мТекущийВидСравненияПоОрганизации = Отчет.ОрганизацияВидСравнения;
	
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
Процедура РегистрБухгалтерииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
		
	СписокВидовОбъектов = Новый СписокЗначений;
	СписокВидовОбъектов.Добавить(фКэшЗначений.ВидОбъектаРегистрБухгалтерии);	
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидыОбъектов"           , СписокВидовОбъектов);
	ПараметрыФормы.Вставить("ТекущийОбъектСистемы"   , Отчет.РегистрБухгалтерии);
	ПараметрыФормы.Вставить("ДоступныеОбъектыСистемы", фКэшЗначений.СписокДоступныхРегистров);
	
	ОткрытьФорму("ОбщаяФорма.бит_ФормаВыбораОбъектовСистемыУправляемая", ПараметрыФормы, Элемент);	
	
КонецПроцедуры // РегистрБухгалтерииНачалоВыбора()

&НаКлиенте
Процедура РегистрБухгалтерииПриИзменении(Элемент)
	
	Если Отчет.РегистрБухгалтерии <> мТекущийРегистрБухгалтерии Тогда
		
		ИзменениеРегистраБухгалтерииСервер();
		мТекущийРегистрБухгалтерии = Отчет.РегистрБухгалтерии;
		
	КонецЕсли;              	
		
КонецПроцедуры // РегистрБухгалтерииПриИзменении()

&НаКлиенте
Процедура РегистрБухгалтерииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры // РегистрБухгалтерииОчистка()

&НаКлиенте
Процедура РегистрБухгалтерииОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры // РегистрБухгалтерииОткрытие()

&НаКлиенте
Процедура ОрганизацияВидСравненияПриИзменении(Элемент)
	
	Отчет.ОрганизацияИспользование = Истина;
	
	ИзменениеВидаСравненияОрганизация(мТекущийВидСравненияПоОрганизации);
	
	мТекущийВидСравненияПоОрганизации = Отчет.ОрганизацияВидСравнения;
	
КонецПроцедуры // ОрганизацияВидСравненияПриИзменении()

&НаКлиенте
Процедура ОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	                             	
	Если ТипЗнч(Отчет.Организация) = Тип("СписокЗначений") Тогда
		
		Элемент.ВыбиратьТип = Ложь;
		
	Иначе
	     	
		бит_РаботаСДиалогамиКлиент.НачалоВыбораСоставного(ЭтаФорма
													   , Элемент
													   , Отчет
													   , Элемент.Имя
													   , фКэшЗначений.СписокВыбораОрганизации
													   , СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры // ОрганизацияНачалоВыбора()

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(ЭтаФорма.Элементы.Результат, "НеАктуальностьОтчета");
	
	УстановитьЗаголовокПоляОрганизации();
	
	Отчет.ОрганизацияИспользование = Истина;
		
КонецПроцедуры // ОрганизацияПриИзменении()
           
&НаКлиенте
Процедура ОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	Если ТипЗнч(Отчет.Организация) = Тип("СписокЗначений") Тогда
	 	Отчет.Организация.Очистить();
	Иначе	
	    Отчет.Организация = Неопределено;
	КонецЕсли;
	
КонецПроцедуры // ОрганизацияОчистка()

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
	
	бит_БухгалтерскиеОтчетыКлиент.РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, Отчет, ЭтаФорма);
	
КонецПроцедуры // РезультатОбработкаРасшифровки()

&НаКлиенте
Процедура ПоВалютамПриИзменении(Элемент)
	
	ПоВалютамПриИзмененииСервер();
	
КонецПроцедуры // ПоВалютамПриИзменении()

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
Процедура СубконтоПередУдалением(Элемент, Отказ)
	      		
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Субконто.ТекущиеДанные;
	Ид = ?(ТекущиеДанные = Неопределено, Неопределено, ТекущиеДанные.ПолучитьИдентификатор());
	
	ИзменениеВидаСубконтоСервер(Ид, Истина);
	
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальностьОтчета");
	
КонецПроцедуры // СубконтоПередУдалением()
   
&НаКлиенте
Процедура СубконтоВидСубконтоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Субконто.ТекущиеДанные;
	Ид = ?(ТекущиеДанные = Неопределено, Неопределено, ТекущиеДанные.ПолучитьИдентификатор());
	
	ИзменениеВидаСубконтоСервер(Ид);
	
КонецПроцедуры // СубконтоВидСубконтоПриИзменении()

&НаКлиенте
Процедура СубконтоВидСубконтоОчистка(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Субконто.ТекущиеДанные;
	Ид = ?(ТекущиеДанные = Неопределено, Неопределено, ТекущиеДанные.ПолучитьИдентификатор());
	
	ИзменениеВидаСубконтоСервер(Ид, Истина);
	
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальностьОтчета");
		
КонецПроцедуры // СубконтоВидСубконтоОчистка()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаОтбор

&НаКлиенте
Процедура ТаблицаОтборПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если НоваяСтрока И Не Копирование Тогда

		ТекущиеДанные = Элементы.ТаблицаОтбор.ТекущиеДанные;		

		Если Копирование Тогда
			ТекущиеДанные.ПутьКДанным   = "";
			ТекущиеДанные.Представление = "";
		Иначе
			ТекущиеДанные.Использование  = Истина;  
			ТекущиеДанные.ВидСравнения   = фКэшЗначений.ВидСравненияРавно; 
		КонецЕсли; 	

		// СтрПар = Новый Структура("ТекстЗапроса, МассивСубконто", фТекстЗапроса, фКэшЗначений.МассивСубконто);
		// бит_мпд_Клиент.ОткрытьФормуПолейПостроителя(ТекущиеДанные, "ТаблицаОтбор", "ПутьКДанным", "Отбор", "", СтрПар);
 		
	КонецЕсли; 
	
КонецПроцедуры // ТаблицаОтборПриНачалеРедактирования()

&НаКлиенте
Процедура ТаблицаОтборПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальностьОтчета");
		
КонецПроцедуры // ТаблицаОтборПриОкончанииРедактирования()

&НаКлиенте
Процедура ТаблицаОтборПослеУдаления(Элемент)
	
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальностьОтчета");
	
КонецПроцедуры // ТаблицаОтборПослеУдаления()

&НаКлиенте
Процедура ТаблицаОтборПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ТаблицаОтбор.ТекущиеДанные;
	
	СтрПар = Новый Структура("ТекстЗапроса, МассивСубконто", фТекстЗапроса, фКэшЗначений.МассивСубконто);				  
	бит_мпд_Клиент.ОткрытьФормуПолейПостроителя(ТекущиеДанные, "ТаблицаОтбор", "ПутьКДанным", "Отбор", "", СтрПар, Элемент);
	
КонецПроцедуры // ТаблицаОтборПредставлениеНачалоВыбора()

&НаКлиенте
Процедура ТаблицаОтборВидСравненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицаОтбор.ТекущиеДанные;
	мТекущийВидСравнения = ТекущиеДанные.ВидСравнения;
	
	СписокВидов = СформироватьСписокВыбораВидаСравнения(ТекущиеДанные.ПолучитьИдентификатор());
	Элемент.СписокВыбора.ЗагрузитьЗначения(СписокВидов.ВыгрузитьЗначения());
	
КонецПроцедуры // ТаблицаОтборВидСравненияНачалоВыбора()

&НаКлиенте
Процедура ТаблицаОтборВидСравненияАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицаОтбор.ТекущиеДанные;
	мТекущийВидСравнения = ТекущиеДанные.ВидСравнения;
	
	СписокВидов = СформироватьСписокВыбораВидаСравнения(ТекущиеДанные.ПолучитьИдентификатор());
	Элемент.СписокВыбора.ЗагрузитьЗначения(СписокВидов.ВыгрузитьЗначения());
	
КонецПроцедуры // ТаблицаОтборВидСравненияАвтоПодбор()

&НаКлиенте
Процедура ТаблицаОтборВидСравненияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТаблицаОтбор.ТекущиеДанные;
	ИзменениеВидаСравненияСервер(ТекущиеДанные.ПолучитьИдентификатор(), мТекущийВидСравнения);
	
КонецПроцедуры // ТаблицаОтборВидСравненияПриИзменении()

&НаКлиенте
Процедура ТаблицаОтборЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицаОтбор.ТекущиеДанные;	
	бит_мпд_Клиент.ТаблицаОтборЗначениеНачалоВыбора(ЭтаФорма
												, ТекущиеДанные
												, Элемент
												, ДанныеВыбора
												, СтандартнаяОбработка);
                                               	
КонецПроцедуры // ТаблицаОтборЗначениеНачалоВыбора()

&НаКлиенте
Процедура ТаблицаОтборЗначениеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТаблицаОтбор.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.Значение) Тогда
		ТекущиеДанные.Использование = Истина;	
	КонецЕсли;
	
КонецПроцедуры // ТаблицаОтборЗначениеПриИзменении()

// Процедура - обработчик события "ПриИзменении" 
// полей ввода "ТаблицаОтборЗначениеС" и "ТаблицаОтборЗначениеПо".
// 
&НаКлиенте
Процедура ТаблицаОтборИнтервалЗначенияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТаблицаОтбор.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.ЗначениеС) И ЗначениеЗаполнено(ТекущиеДанные.ЗначениеПо) Тогда
		ТекущиеДанные.Использование = Истина;	
	КонецЕсли;
	
КонецПроцедуры // ТаблицаОтборЗначениеПриИзменении()

&НаКлиенте
Процедура ТаблицаОтборЗначениеОчистка(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицаОтбор.ТекущиеДанные;	
	бит_мпд_Клиент.ТаблицаОтборЗначениеОчистка(ТекущиеДанные, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры // ТаблицаОтборЗначениеОчистка()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаСортировки

&НаКлиенте
Процедура ТаблицаСортировкиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальностьОтчета");
	
КонецПроцедуры // ТаблицаСортировкиПриОкончанииРедактирования()

&НаКлиенте
Процедура ТаблицаСортировкиПослеУдаления(Элемент)
	
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальностьОтчета");
	
КонецПроцедуры // ТаблицаСортировкиПослеУдаления()

&НаКлиенте
Процедура ТаблицаСортировкиПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ТаблицаСортировки.ТекущиеДанные;
	
	СтрПар = Новый Структура("ТекстЗапроса, МассивСубконто", фТекстЗапроса, фКэшЗначений.МассивСубконто);				  
	бит_мпд_Клиент.ОткрытьФормуПолейПостроителя(ТекущиеДанные, "ТаблицаСортировки", "ПутьКДанным", "Порядок", "", СтрПар, Элемент);
	    												
КонецПроцедуры // ТаблицаСортировкиПредставлениеНачалоВыбора()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаГруппировки

&НаКлиенте
Процедура ТаблицаГруппировкиПриОкончанииРедактирования(Элемент, НоваяСтрока, Копирование)
	
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальностьОтчета");
	
КонецПроцедуры // ТаблицаГруппировкииПриОкончанииРедактирования()

&НаКлиенте
Процедура ТаблицаГруппировкиПослеУдаления(Элемент)
	
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальностьОтчета");
	
КонецПроцедуры // ТаблицаГруппировкиПослеУдаления()

&НаКлиенте
Процедура ТаблицаГруппировкиПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ТаблицаГруппировки.ТекущиеДанные;
	
	СтрПар = Новый Структура("ТекстЗапроса, МассивСубконто", фТекстЗапроса, фКэшЗначений.МассивСубконто);
	бит_мпд_Клиент.ОткрытьФормуПолейПостроителя(ТекущиеДанные, "ТаблицаГруппировки", "ПутьКДанным", "Измерение", "", СтрПар, Элемент);
	ИзменениеПредставленияГруппировкиСервер(ТекущиеДанные.ПолучитьИдентификатор());
	
КонецПроцедуры // ТаблицаГруппировкиПредставлениеНачалоВыбора()

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
	
	ОбновитьПанельСохраненныхНастроек(Истина, , , мТекущийРегистрБухгалтерии);	
	
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

&НаКлиенте
Процедура ОтборУстановитьВсе(Команда)
	
	бит_ОбщегоНазначенияКлиентСервер.ОбработатьФлаги(ТаблицаОтбор, "Использование", 1);
	
КонецПроцедуры // ОтборУстановитьВсе()

&НаКлиенте
Процедура ОтборСнятьВсе(Команда)
	
	бит_ОбщегоНазначенияКлиентСервер.ОбработатьФлаги(ТаблицаОтбор, "Использование", 0);
	
КонецПроцедуры // ОтборСнятьВсе()

&НаКлиенте
Процедура ОтборИнвертировать(Команда)
	
	бит_ОбщегоНазначенияКлиентСервер.ОбработатьФлаги(ТаблицаОтбор, "Использование", 2);
	
КонецПроцедуры // ОтборИнвертировать()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроцедурыИФункцииПоРаботеСНастройками

// Функция создает структуру, хранящую настройки.
// 
// Возвращаемое значение:
//   СтруктураНастроек - Структура.
// 
&НаСервере
Функция УпаковатьНастройкиВСтруктуру()

	СтруктураНастроек = бит_БухгалтерскиеОтчетыСервер.УпаковатьНастройкиОтчетаВСтруктуру(Отчет, ЭтаФорма);
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
	
	бит_БухгалтерскиеОтчетыСервер.ПрименитьНастройкиОтчета(Отчет, ЭтаФорма, ВыбНастройка, ТекущийРегистрБухгалтерии);
	
	Если ВыделитьТекущуюНастройку Тогда 		
		бит_ОтчетыСервер.ВыделитьТекущуюСохраненнуюНастройку(Элементы, 
															фСтруктураСохраненныхНастроек, 
															фИмяЭлемента_ВыбраннаяНастройка,
															,
															ВыбНастройка.КлючНастройки);
	КонецЕсли;
	
	УстановитьЗаголовокПоляОрганизации();
		
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
											ЭтаФорма);	
													
КонецПроцедуры // ДействияФормыНастройкиСохранить()

// Процедура - обработчик события "Нажатие" кнопки "НастройкиВосстановить" 
// коммандной панели "ДействияФормы".
// 
&НаКлиенте
Процедура ДействияФормыНастройкиВосстановить(Кнопка)
	
	ПараметрыФормы     = Новый Структура;
	ПараметрыФормы.Вставить("ТипНастройки"		 , фКэшЗначений.ТипНастройки);
	ПараметрыФормы.Вставить("НастраиваемыйОбъект", фКэшЗначений.НастраиваемыйОбъект);
	
	Обработчик = Новый ОписаниеОповещения("НастройкиВосстановитьЗавершение", ЭтотОбъект);
	ОткрытьФорму("ХранилищеНастроек.бит_ХранилищеНастроек.ФормаЗагрузки"
					, ПараметрыФормы, ЭтаФорма, , , , Обработчик, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс); 							
		
КонецПроцедуры // ДействияФормыНастройкиВосстановить()

// Процедура - завершение обработчика события "Нажатие" кнопки "НастройкиВосстановить" 
// коммандной панели "ДействияФормы".
// 
&НаКлиенте
Процедура НастройкиВосстановитьЗавершение(Настройка, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(Настройка) Тогда		
		ПрименитьНастройки(Настройка, мТекущийРегистрБухгалтерии, Истина);		
	КонецЕсли;
	
КонецПроцедуры // НастройкиВосстановитьЗавершение()

#КонецОбласти

// Процедура заполняет кэш значений, необходимый при работе на клиенте.
// 
// Параметры:
// 
&НаСервере
Процедура ЗаполнитьКэшЗначений()

	фКэшЗначений = Новый Структура;
	
	ИмяТипаОбъекта = СтрЗаменить(фПолноеИмяОтчета, "Отчет.", "ОтчетОбъект.");
	фКэшЗначений.Вставить("ИмяТипаОбъекта", ИмяТипаОбъекта);
	
	ОтчетОб = ДанныеФормыВЗначение(Отчет, Тип(ИмяТипаОбъекта));
	МетаданныеОбъекта = ОтчетОб.Метаданные();
	
	бит_БухгалтерскиеОтчетыСервер.ЗаполнитьПризнакиПоТипуОтчета(фКэшЗначений, ЭтаФорма, МетаданныеОбъекта);
	бит_БухгалтерскиеОтчетыСервер.ЗаполнитьПризнакиПоМетаданным(фКэшЗначений, МетаданныеОбъекта);
	бит_БухгалтерскиеОтчетыСервер.ЗаполнитьПризнакиПоДаннымФормы(фКэшЗначений, ЭтаФорма);
			                    		
	фКэшЗначений.Вставить("ТипНастройки"	   , Перечисления.бит_ТипыСохраненныхНастроек.Отчеты);
	фКэшЗначений.Вставить("НастраиваемыйОбъект", фПолноеИмяОтчета + "_Построитель");
	
	фКэшЗначений.Вставить("ВидСравненияРавно", ВидСравнения.Равно);
	
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
		          	
КонецПроцедуры // УправлениеВидимостьюДоступностью()

// Процедура устанавливает заголовок поля организации.
// 
&НаСервере
Процедура УстановитьЗаголовокПоляОрганизации()
	
	бит_БухгалтерскиеОтчетыСервер.УстановитьЗаголовокПоляОрганизации(Элементы.ОрганизацияИспользование, Отчет);
			
КонецПроцедуры // УстановитьЗаголовокПоляОрганизации()

// Устанавливает отбор по организации в таблицу отборов.
// 
&НаСервере
Процедура ИзменениеВидаСравненияОрганизация(ПредВидСравнения)
	
	бит_БухгалтерскиеОтчетыСервер.ИзменениеВидаСравненияОрганизация(Отчет, ПредВидСравнения, Истина);
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(ЭтаФорма.Элементы.Результат, "НеАктуальностьОтчета");
	
	УстановитьЗаголовокПоляОрганизации();
	
КонецПроцедуры // ИзменениеВидаСравненияОрганизация()

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
																		, ЭтаФорма
																		, ИмяЭлемента
																		, СоответствиеРезультатов
																		, ТекущийРегистрБухгалтерии
																		, Истина);
	
	УстановитьЗаголовокПоляОрганизации();

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
											, ЭтаФорма
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
	
	бит_БухгалтерскиеОтчетыСервер.УстановитьЗначенияНастроекОтчетовПоУмолчанию(Отчет, ЭтаФорма, фКэшЗначений.ИмяТипаОбъекта);
		
	бит_ОтчетыСервер.ВыделитьТекущуюСохраненнуюНастройку(Элементы, фСтруктураСохраненныхНастроек, фИмяЭлемента_ВыбраннаяНастройка);
														
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальностьОтчета");
	
	ИзменениеРегистраБухгалтерииСервер();
	
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
	бит_БухгалтерскиеОтчетыСервер.СинхронизироватьДанныеОтчета(Отчет, ОтчетОб, ЭтаФорма);
		
	// Формирование результата	
	ОтчетСформирован = ОтчетОб.СформироватьОтчет(Результат, фПоказыватьЗаголовок, фВысотаЗаголовка);
	ЗначениеВДанныеФормы(ОтчетОб, Отчет);
	
	Если ОтчетСформирован Тогда
		бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат);
	КонецЕсли;
	
	Если фСкрыватьНастройкиПриФормированииОтчета Тогда
		ОбработкаКомандыПанелиНастроекСервер(Истина);	
	КонецЕсли;
	
	бит_ук_СлужебныйСервер.РегистрацияФормированиеОтчета(Ложь, СтрРегистрация);

КонецПроцедуры // ОбновитьОтчет()

// Процедура выполняет действия, необходимые при изменении регистра бухгалтерии.
// 
&НаСервере
Процедура ИзменениеРегистраБухгалтерииСервер()

	бит_БухгалтерскиеОтчетыСервер.ПерезаполнитьДанныеПоРегиструБухгалтерии(Отчет, ЭтаФорма, фКэшЗначений.ИмяТипаОбъекта);
	бит_БухгалтерскиеОтчетыСервер.ПерезаполнитьПризнакиУчета(Отчет, ЭтаФорма);
	
КонецПроцедуры // ИзменениеРегистраБухгалтерииСервер() 
           
// Функция возвращает список доступных видов сравнения в зависимости от типа значения в строке.
// 
// Параметры:
//  ИдСтроки - Число.
// 
&НаСервере
Функция СформироватьСписокВыбораВидаСравнения(ИдСтроки)
	
	ТекущиеДанные = ТаблицаОтбор.НайтиПоИдентификатору(ИдСтроки);
	СписокВидов = бит_МеханизмПолученияДанных.СписокВыбораВидаСравнения(ТекущиеДанные);
	
    Возврат СписокВидов;
	
КонецФункции // СформироватьСписокВыбораВидаСравнения()

// Процедура обрабатывает изменение вида сравнения.
// 
// Параметры:
//  ИдСтроки         - Строка.
//  ПредВидСравнения - ВидСравнения.
// 
&НаСервере
Процедура ИзменениеВидаСравненияСервер(ИдСтроки, ПредВидСравнения)
	
	ТекущиеДанные = ТаблицаОтбор.НайтиПоИдентификатору(ИдСтроки); 	
	бит_МеханизмПолученияДанных.ИзменениеВидаСравнения(ТекущиеДанные, ПредВидСравнения);
		
КонецПроцедуры // ИзменениеВидаСравненияСервер()

// Процедура перезаполняет отборы.
// 
// Параметры:
//  Ид 			- Строка (По умолчанию = Неопределено).
//  ЭтоУдаление - Булево (По умолчанию = Ложь).
// 
&НаСервере
Процедура ИзменениеВидаСубконтоСервер(Ид = Неопределено, ЭтоУдаление = Ложь)

	бит_БухгалтерскиеОтчетыСервер.ПерезаполнитьДанныеФормыПоСубконто(Отчет, ЭтаФорма, Ид, ЭтоУдаление, Истина);
			
	бит_ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальностьОтчета");
		
КонецПроцедуры // ИзменениеВидаСубконтоСервер()

&НаСервере
Процедура ПоВалютамПриИзмененииСервер()
	
	бит_БухгалтерскиеОтчетыСервер.ПерезаполнитьОтборПоВалюте(Отчет, ЭтаФорма);
	бит_БухгалтерскиеОтчетыСервер.ПерезаполнитьТекстЗапроса(Отчет, ЭтаФорма);
	
КонецПроцедуры // ПоВалютамПриИзменении()

// Процедура выполняет действия, необходимые при изменении представления детализации счета.
// 
// Параметры:
//  ИдСтроки - Строка
// 
&НаСервере
Процедура ИзменениеПредставленияГруппировкиСервер(ИдСтроки)
	                  
	ТекущиеДанные = ТаблицаГруппировки.НайтиПоИдентификатору(ИдСтроки);
	
	ОтчетОб = ДанныеФормыВЗначение(Отчет, Тип(ЭтаФорма.фКэшЗначений.ИмяТипаОбъекта));
	бит_БухгалтерскиеОтчетыСервер.УстановитьТипИзмеренияПоУмолчанию(ТекущиеДанные, ОтчетОб.ПостроительОтчета);

КонецПроцедуры // ИзменениеПредставленияГруппировкиСервер()

#КонецОбласти
