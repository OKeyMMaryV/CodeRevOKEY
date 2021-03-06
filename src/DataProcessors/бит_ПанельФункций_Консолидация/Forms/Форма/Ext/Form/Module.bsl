
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);

	ПодключитьСхемы();
		
КонецПроцедуры// ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СхемаПорталВГОВыбор(Элемент)
	
	ИмяЭлемента = Элемент.ТекущийЭлемент.Имя;
	// Для дублирующихся элементов убираем номер из имени.
	ИмяЭлемента = СтрЗаменить(ИмяЭлемента, "_ФормаСписка1","_ФормаСписка");
	бит_РаботаСДиалогамиКлиент.ОткрытьФормуПоИмени(ИмяЭлемента, Новый Структура("ПреобразоватьИзИмени",Истина));

КонецПроцедуры

&НаКлиенте
Процедура СхемаФСДВыбор(Элемент)
	
	ИмяЭлемента = Элемент.ТекущийЭлемент.Имя;
	// Для дублирующихся элементов убираем номер из имени.
	ИмяЭлемента = СтрЗаменить(ИмяЭлемента, "_ФормаСписка1","_ФормаСписка");
	бит_РаботаСДиалогамиКлиент.ОткрытьФормуПоИмени(ИмяЭлемента, Новый Структура("ПреобразоватьИзИмени",Истина));

КонецПроцедуры

&НаКлиенте
Процедура СхемаКонсолидацияВыбор(Элемент)
	
	ИмяЭлемента = Элемент.ТекущийЭлемент.Имя;
	// Для дублирующихся элементов убираем номер из имени.
	ИмяЭлемента = СтрЗаменить(ИмяЭлемента, "_ФормаСписка1","_ФормаСписка");
	бит_РаботаСДиалогамиКлиент.ОткрытьФормуПоИмени(ИмяЭлемента, Новый Структура("ПреобразоватьИзИмени",Истина));

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНажатие(Элемент)
	
	ИмяЭлемента = Элемент.Имя;
	// Для дублирующихся элементов убираем номер из имени.
	ИмяЭлемента = СтрЗаменить(ИмяЭлемента, "_ФормаСписка1","_ФормаСписка");
	ИмяЭлемента = СтрЗаменить(ИмяЭлемента, "_Форма1","_Форма");
	бит_РаботаСДиалогамиКлиент.ОткрытьФормуПоИмени(ИмяЭлемента, Новый Структура("ПреобразоватьИзИмени",Истина));
	
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура подключает макеты-схемы.
//
&НаСервере
Процедура ПодключитьСхемы()
	
	// Устанавливаем графические схемы
	СхемаПорталВГО 	  = Обработки.бит_ПанельФункций_Консолидация.ПолучитьМакет("СхемаПорталВГО");
	СхемаФСД 		  = Обработки.бит_ПанельФункций_Консолидация.ПолучитьМакет("СхемаФСД");
	СхемаКонсолидация = Обработки.бит_ПанельФункций_Консолидация.ПолучитьМакет("СхемаКонсолидация");
	
КонецПроцедуры// ПодключитьСхемы()

#КонецОбласти
 


