#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗагрузитьЗначенияНастроек();
	
	Если ПустаяСтрока(АдресСайта) Тогда
		Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
		Склад = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнойСклад");
		
		CMSИнтернетМагазина = Перечисления.CMSИнтернетМагазина.Bitrix;
		Префикс = ПрефиксПоУмолчанию();
		ВидНоменклатуры = Справочники.ВидыНоменклатуры.ЭлементВидНоменклатурыПоУмолчанию(Ложь);
		
		ДатаНачалаОбмена = НачалоДня(ТекущаяДатаСеанса())-1;
		ЗапрещенныеСтатусы = Новый СписокЗначений;
		ЗапрещенныеСтатусы.Добавить("Новый", НСтр("ru = 'Новый'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
		
	КонецЕсли;
	
	СписокВыбора = Элементы.CMSИнтернетМагазина.СписокВыбора;
	Для каждого CMS Из Перечисления.CMSИнтернетМагазина Цикл
		СписокВыбора.Добавить(CMS,,, ОбменСИнтернетМагазином.ЛоготипCMS(CMS));
	КонецЦикла;
	
	РеквизитыНовойНоменклатуры = НСтр("ru = 'Реквизиты новой номенклатуры'");
	
	Элементы.ГруппаНастройкиПодключения.Видимость = НЕ Параметры.НастройкаРеквизитов;
	Элементы.ГруппаНастройкиПодключения.Видимость = НЕ Параметры.НастройкаРеквизитов;
	Элементы.ГруппаСтатусыЗаказа.Видимость        = НЕ Параметры.НастройкаРеквизитов;
	Элементы.ПрефиксНовыхДокументов.Видимость     = НЕ Параметры.НастройкаРеквизитов;
	Элементы.Организация.Видимость                = НЕ Параметры.НастройкаРеквизитов;
	Элементы.Склад.Видимость                      = НЕ Параметры.НастройкаРеквизитов;
	
	УстановитьПредставлениеАдресСайта(ЭтотОбъект);

	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если СоздаватьНовуюНоменклатуру тогда
		Если НЕ ЗначениеЗаполнено(ВидНоменклатуры) Тогда
			Отказ = Истина;
			СообщениеОбОшибке = НСтр("ru = 'Необходимо заполнить реквизиты новой номенклатуры'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РеквизитыНовойНоменклатурыНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура();
	ЗначенияРеквизитов = Новый Структура;
	ЗначенияРеквизитов.Вставить("Родитель",             ГруппаНоменклатуры);
	ЗначенияРеквизитов.Вставить("ВидНоменклатуры",      ВидНоменклатуры);
	ЗначенияРеквизитов.Вставить("НоменклатурнаяГруппа", НоменклатурнаяГруппа);
	
	ПараметрыФормы.Вставить("ЗначенияРеквизитов", ЗначенияРеквизитов);
	ПараметрыФормы.Вставить("ЕстьКолонкаСтавкаНДС",        Истина);
	ПараметрыФормы.Вставить("ЕстьКолонкаЕдиницаИзмерения", Истина);
	
	ОписаниеЗавершения = Новый ОписаниеОповещения("РеквизитыНовойНоменклатурыЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ФормаУстановкиЗначенийРеквизитовНоменклатуры", ПараметрыФормы,,,,,ОписаниеЗавершения);

КонецПроцедуры

&НаКлиенте
Процедура СтатусЗаказаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ИзменениеСтатусовЗавершение", ЭтотОбъект);
	ПараметрыФомы = Новый Структура("Статусы", ЗапрещенныеСтатусы.ВыгрузитьЗначения());
	
	ОткрытьФорму("Обработка.ОбменСИнтернетМагазином.Форма.ФормаСпискаСтатусов", ПараметрыФомы, ЭтотОбъект,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	ПарольИзменен = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПостатусамПриИзменении(Элемент)
	Элементы.СтатусЗаказа.Доступность = ИспользоватьОтборПостатусам;
КонецПроцедуры

&НаКлиенте
Процедура CMSИнтернетМагазинаПриИзменении(Элемент)
	
	УстановитьПредставлениеАдресСайта(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		СохранитьНастройки();
		Оповестить("ИзменениеНастройкиОбменаСИнтернетМагазином");
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключение(Команда)

	ТекстСообщения = "";
	
	ПроверитьПодключениеНаСервере(НастройкиПодключения(), ТекстСообщения);
	
	ПоказатьПредупреждение(, ТекстСообщения);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗагрузитьЗначенияНастроек()
	
	СохраненныеНастройки = ОбменСИнтернетМагазином.ПолучитьНастройкиОбмена();
	Если СохраненныеНастройки <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СохраненныеНастройки);
		Статусы = СохраненныеНастройки.ЗапрещенныеСтатусы.Получить();
		Если Статусы <> Неопределено Тогда
			ЗапрещенныеСтатусы.ЗагрузитьЗначения(Статусы);
		КонецЕсли;
		Пароль = УникальныйИдентификатор;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	Настройки = РегистрыСведений.НастройкиОбменаСИнтернетМагазином.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Настройки, ЭтотОбъект);
	Если ЗапрещенныеСтатусы.Количество() > 0 Тогда
		Настройки.ЗапрещенныеСтатусы = Новый ХранилищеЗначения(ЗапрещенныеСтатусы.ВыгрузитьЗначения());
	КонецЕсли;
	Настройки.Записать();
	
	Если ПарольИзменен Тогда
		УстановитьПривилегированныйРежим(Истина);
		ИдентификаторПодсистемы = ОбменСИнтернетМагазином.ИдентификаторПодсистемы();
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ИдентификаторПодсистемы, Пароль);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПрефиксПоУмолчанию()
	
	ПрефиксИнформационнойБазы = ОбменДаннымиСервер.ПрефиксИнформационнойБазы();
	
	Возврат ?(ПрефиксИнформационнойБазы = "ИМ", "", "ИМ");
	
КонецФункции

&НаСервереБезКонтекста
Процедура ПроверитьПодключениеНаСервере(Знач НастройкиПодключения, ТекстПредупреждения)
	
	Обработки.ОбменСИнтернетМагазином.ВыполнитьТестовоеПодключение(НастройкиПодключения, ТекстПредупреждения);
	
КонецПроцедуры

&НаКлиенте
Функция НастройкиПодключения()
	
	СтруктураНастроек = Новый Структура;
	
	СтруктураНастроек.Вставить("CMSИнтернетМагазина", CMSИнтернетМагазина);
	СтруктураНастроек.Вставить("АдресСайта",          АдресСайта);
	СтруктураНастроек.Вставить("Пользователь",        Пользователь);
	Если ПарольИзменен Тогда
		СтруктураНастроек.Вставить("Пароль",              Пароль);
	КонецЕсли;
	
	Возврат СтруктураНастроек;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	ПредставлениеСписка = "";
	Если Форма.ЗапрещенныеСтатусы.Количество() = 0 Тогда
		Форма.ИспользоватьОтборПостатусам = Ложь;
		ПредставлениеСписка = НСтр("ru = '<статус не задан>'");
	Иначе
		Для каждого Статус из Форма.ЗапрещенныеСтатусы Цикл
			СтатусСтрокой = ?(ПустаяСтрока(Статус.Значение), НСтр("ru = '<пустой>'"), """" + Статус.значение+ """");
			ПредставлениеСписка = ПредставлениеСписка + СтатусСтрокой + ", ";
		КонецЦикла;
		ПредставлениеСписка = Лев(ПредставлениеСписка, СтрДлина(ПредставлениеСписка)-2);
	КонецЕсли;
	
	Форма.СтатусЗаказа = ПредставлениеСписка;
	
	Элементы.СтатусЗаказа.Доступность = Форма.ИспользоватьОтборПостатусам;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредставлениеАдресСайта(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Форма.CMSИнтернетМагазина = ПредопределенноеЗначение("Перечисление.CMSИнтернетМагазина.Другая") Тогда
		Элементы.АдресСайта.Заголовок = НСтр("ru = 'Адрес скрипта'");
		Элементы.АдресСайта.ПодсказкаВвода = НСтр("ru = 'http://<ваш_сайт>/<путь>/1c_exchange.php'");
	Иначе
		Элементы.АдресСайта.Заголовок = НСтр("ru = 'Адрес сайта'");
		Элементы.АдресСайта.ПодсказкаВвода = НСтр("ru = 'http://имя_вашего_сайта.рф'");
	КонецЕсли;
	

КонецПроцедуры

#Область ОбработчикиОповещения
&НаКлиенте
Процедура ИзменениеСтатусовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		ЗапрещенныеСтатусы.ЗагрузитьЗначения(Результат);
		Модифицированность =Истина;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыНовойНоменклатурыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено И НЕ Результат = КодВозвратаДиалога.Отмена Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Результат);
		ГруппаНоменклатуры = Результат.Родитель;
		Модифицированность =Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти






