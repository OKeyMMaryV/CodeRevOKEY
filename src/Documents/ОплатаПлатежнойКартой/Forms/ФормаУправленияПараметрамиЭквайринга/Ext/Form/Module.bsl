#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Эквайер           = Параметры.Эквайер;
	ДоговорЭквайринга = Параметры.ДоговорЭквайринга;
	СчетРасчетов      = Параметры.СчетРасчетов;
	Организация       = Параметры.Организация;
	
	ЭтаФорма.ТолькоПросмотр = Параметры.ТолькоПросмотр;
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ВестиУчетПоДоговорам = ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам");
		
	//ОКЕЙ Балыков А.Г.(ПервыйБИТ) Начало 2021-04-26 (#ТП_БП11_ФР04)
	ок_МодификацияКонфигурацииПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	ок_УстановитьОтображениеЭлементов();
	//ОКЕЙ Балыков А.Г.(ПервыйБИТ) Конец 2021-04-26 (#ТП_БП11_ФР04)
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДоговорЭквайрингаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗначенияЗаполнения = Новый Структура;
	ВидыДоговора = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
		ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Прочее"));

	ЗначенияЗаполнения.Вставить("Организация", Организация);
	ЗначенияЗаполнения.Вставить("Владелец",    Эквайер);
	ЗначенияЗаполнения.Вставить("ВидДоговора", Новый ФиксированныйМассив(ВидыДоговора));
	ЗначенияЗаполнения.Вставить("ВалютаВзаиморасчетов", ВалютаРегламентированногоУчета);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ДоговорЭквайринга);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ДоговорЭквайрингаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВидыДоговора = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
		ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Прочее"));
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Организация", Организация);
	СтруктураОтбора.Вставить("Владелец",    Эквайер);
	СтруктураОтбора.Вставить("ВидДоговора", Новый ФиксированныйМассив(ВидыДоговора));
	СтруктураОтбора.Вставить("ВалютаВзаиморасчетов", ВалютаРегламентированногоУчета);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", СтруктураОтбора);
	
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаВыбора", ПараметрыФормы, Элемент);

КонецПроцедуры

//ОКЕЙ Балыков А.Г.(ПервыйБИТ) Начало 2021-04-26 (#ТП_БП11_ФР04)	
&НаКлиенте
Процедура Подключаемый_СчетРасчетовПриИзменении(Элемент)
	
	ок_УстановитьОтображениеЭлементов();
	
КонецПроцедуры
//ОКЕЙ Балыков А.Г.(ПервыйБИТ) Конец 2021-04-26 (#ТП_БП11_ФР04)

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Принять(Команда)
	
	ПараметрыВозврата = Новый Структура;
	
	Если НЕ ВестиУчетПоДоговорам И НЕ ЗначениеЗаполнено(ДоговорЭквайринга) Тогда
		ДоговорЭквайринга = НайтиСоздатьДоговорЭквайринга(Организация, Эквайер);
	КонецЕсли;
	
	ПараметрыВозврата.Вставить("Эквайер", Эквайер);
	ПараметрыВозврата.Вставить("ДоговорЭквайринга", ДоговорЭквайринга);
	ПараметрыВозврата.Вставить("СчетКасса", СчетРасчетов);
	ПараметрыВозврата.Вставить("Модифицированность", Модифицированность);
	//ОКЕЙ Балыков А.Г.(ПервыйБИТ) Начало 2021-04-26 (#ТП_БП11_ФР04)
	ПараметрыВозврата.Вставить("ок_ВидыПереводов ", ЭтаФорма.ок_ВидыПереводов);
	ПараметрыВозврата.Вставить("ок_СтатьяДвиженияДенежныхСредств ", ЭтаФорма.ок_СтатьяДвиженияДенежныхСредств);
	//ОКЕЙ Балыков А.Г.(ПервыйБИТ) Конец 2021-04-26 (#ТП_БП11_ФР04)
	
	ЭтаФорма.Закрыть(ПараметрыВозврата);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиСоздатьДоговорЭквайринга(Знач Организация, Знач Эквайер)
	
	ПараметрыДоговора = Новый Структура;
	ПараметрыДоговора.Вставить("ВидДоговора", Перечисления.ВидыДоговоровКонтрагентов.Прочее);
	ПараметрыДоговора.Вставить("Организация", Организация);
	ПараметрыДоговора.Вставить("Владелец",    Эквайер);
	
	ДоговорЭквайринга = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	РаботаСДоговорамиКонтрагентовБП.УстановитьДоговорКонтрагента(
		ДоговорЭквайринга, 
		ПараметрыДоговора.Владелец, 
		ПараметрыДоговора.Организация, 
		ПараметрыДоговора.ВидДоговора);
	
	Если НЕ ЗначениеЗаполнено(ДоговорЭквайринга) Тогда
		ПараметрыСоздания = Новый Структура("ЗначенияЗаполнения", ПараметрыДоговора);
		ДоговорЭквайринга = РаботаСДоговорамиКонтрагентовБПВызовСервера.СоздатьОсновнойДоговорКонтрагента(ПараметрыСоздания);
	КонецЕсли;
	
	Возврат ДоговорЭквайринга;
	
КонецФункции

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	ПеренестиВДокумент = Ложь;
	Закрыть();
	
КонецПроцедуры

//ОКЕЙ Балыков А.Г.(ПервыйБИТ) Начало 2021-04-26 (#ТП_БП11_ФР04)	
&НаСервере
Процедура ок_УстановитьОтображениеЭлементов()
	
	Если СчетРасчетов = ПланыСчетов.Хозрасчетный.ПереводыВПути Тогда
		Элементы.ок_ВидыПереводов.Видимость 				= Истина;
		Элементы.ок_СтатьяДвиженияДенежныхСредств.Видимость = Истина;
		Элементы.Эквайер.Видимость							= Ложь;
		Элементы.ДоговорЭквайринга.Видимость				= Ложь;
	Иначе
		Элементы.ок_ВидыПереводов.Видимость 				= Ложь;
		Элементы.ок_СтатьяДвиженияДенежныхСредств.Видимость = Ложь;
		Элементы.Эквайер.Видимость							= Истина;
		Элементы.ДоговорЭквайринга.Видимость				= Истина;
	КонецЕсли;
	
КонецПроцедуры
//ОКЕЙ Балыков А.Г.(ПервыйБИТ) Конец 2021-04-26 (#ТП_БП11_ФР04)

#КонецОбласти