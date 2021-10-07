﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПустаяСтрока(Параметры.АдресПараметровВХранилище) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	
	// "Распаковываем" параметры
	ПараметрыРасчета = ПолучитьИзВременногоХранилища(Параметры.АдресПараметровВХранилище);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыРасчета, , "Объект");
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыРасчета.Объект);
	ЗаполнитьЗначенияСвойств(Объект,
								ПараметрыРасчета.Объект,
								,
								"Начисления,СреднийЗаработокФСС,ОтработанноеВремяДляСреднегоФСС");
	
	Объект.ОтработанноеВремяДляСреднегоФСС.Загрузить(ПараметрыРасчета.ОтработанноеВремяДляСреднегоФСС);
	Объект.СреднийЗаработокФСС.Загрузить(ПараметрыРасчета.СреднийЗаработокФСС);
	Объект.Начисления.Загрузить(ПараметрыРасчета.Начисления);
	
	РежимПодробногоВводаСреднегоЗаработка =
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиПользователя",
															"РежимПодробногоВводаСреднегоЗаработкаФСС");
	РежимПодробногоВводаСреднегоЗаработкаЧисло = РежимПодробногоВводаСреднегоЗаработка;
	
	Если ПричинаНетрудоспособности <> Перечисления.ПричиныНетрудоспособности.ПоБеременностиИРодам Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Год1ДниУхода1",
			"Видимость",
			Ложь);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Год2ДниУхода1",
			"Видимость",
			Ложь);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ДекорацияДни1",
			"Видимость",
			Ложь);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ДекорацияДни2",
			"Видимость",
			Ложь);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ТаблицаЗаработкаГруппа1",
			"ОтображатьВШапке",
			Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ТаблицаЗаработкаГруппа2",
			"ОтображатьВШапке",
			Ложь);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ТаблицаЗаработкаГод1ДниУхода",
			"Видимость",
			Ложь);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ТаблицаЗаработкаГод2ДниУхода",
			"Видимость",
			Ложь);
			
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"РежимПодробногоВводаСреднегоЗаработкаЧисло",
		"Видимость",
		Не ТолькоПросмотр);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПеречитатьДанныеУчета",
		"Видимость",
		Не ТолькоПросмотр);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"НачисленияРезультатВТомЧислеЗаСчетФБ",
		"Видимость",
		Объект.ПрименятьЛьготыПриНачисленииПособия);
		
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СреднийЗаработокМРОТДекорация",
		"Видимость",
		Объект.ОграничениеПособия = Перечисления.ВидыОграниченияПособия.ОграничениеВРазмереММОТ
		ИЛИ Объект.ОграничениеПособияБезЛьгот = Перечисления.ВидыОграниченияПособия.ОграничениеВРазмереММОТ
		ИЛИ ЗначениеЗаполнено(Объект.ДатаНарушенияРежима)
		ИЛИ Объект.СреднийЗаработокФСС = 0);
		

	ФизическоеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сотрудник, "ФизическоеЛицо");
	
	ПодготовитьТаблицу();
	НастроитьМаксимальноеКоличествоДнейВФеврале(ЭтаФорма);
	
	ОбновитьЗаголовкиТаблицы(ЭтотОбъект);
	
	ЗагрузитьСреднийЗаработокФСС();
	
	ПараметрыРасчета = ПараметрыРасчетаСреднегоДневногоЗаработкаФСС();

	Объект.СреднийДневнойЗаработок = УчетПособийСоциальногоСтрахования.СреднийДневнойЗаработокФСС(ПараметрыРасчета);
	Объект.МинимальныйСреднедневнойЗаработок = 
		УчетПособийСоциальногоСтрахования.МинимальныйСреднедневнойЗаработокФСС(ПараметрыРасчета);
	
	УстановитьПодсказкуКРасчетуСреднегоЗаработка();
	
	УстановитьЗаголовокФормы();
	
	
	Элементы.ГруппаКнопокПросмотр.Видимость       = ТолькоПросмотр;
	Элементы.ГруппаКнопокРедактирование.Видимость = НЕ ТолькоПросмотр;
	Если ТолькоПросмотр Тогда
		Элементы.ФормаЗакрыть.КнопкаПоУмолчанию = Истина;
	Иначе
		Элементы.ФормаОК.КнопкаПоУмолчанию      = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИдентификаторВладельца = ВладелецФормы.УникальныйИдентификатор;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		ВопросСохранитьИзменения();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Год1ПриИзменении(Элемент)
	
	ПриИзмененииРасчетногоГода(0);
	
КонецПроцедуры

&НаКлиенте
Процедура Год1Регулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод = Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод + Направление;
	СтандартнаяОбработка = Ложь;
	Модифицированность = Истина;
	
	ПриИзмененииРасчетногоГода(0);
	
КонецПроцедуры

&НаКлиенте
Процедура Год2ПриИзменении(Элемент)
	
	ПриИзмененииРасчетногоГода(1);
	
КонецПроцедуры

&НаКлиенте
Процедура Год2Регулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Объект.ПериодРасчетаСреднегоЗаработкаВторойГод = Объект.ПериодРасчетаСреднегоЗаработкаВторойГод + Направление;
	СтандартнаяОбработка = Ложь;
	Модифицированность = Истина;
	
	ПриИзмененииРасчетногоГода(1);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПодробногоВводаСреднегоЗаработкаЧислоПриИзменении(Элемент)
	
	РежимПодробногоВводаСреднегоЗаработка = РежимПодробногоВводаСреднегоЗаработкаЧисло;
	Если Не РежимПодробногоВводаСреднегоЗаработка Тогда
		СвернутьДанныеДляКраткойФормы(ЭтаФорма);
	КонецЕсли;
	
	УстановитьОтображениеКраткойПодробнойФормыВвода(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ГодМесяцПриИзменении(Элемент)
	
	Пересчитать();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыТаблицаЗаработка

&НаКлиенте
Процедура ТаблицаЗаработкаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Пересчитать();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНачисления

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура OK(Команда)
	
	Если НЕ Модифицированность ИЛИ ТолькоПросмотр Тогда
		Закрыть();
	Иначе
		ПодготовитьФормуКПринятиюИзменений();
		Закрыть(АдресВХранилище);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПеречитатьДанныеУчета(Команда)
	
	ДанныеЗаполнены = Ложь;
	Для НомерГода = 1 По 2 Цикл
		
		Для НомерМесяца = 1 По 12 Цикл
			
			ИндексМесяца = НомерМесяца - 1;
			
			Заработок = ТаблицаЗаработка[ИндексМесяца]["Год" + НомерГода + "Месяц"];
				
			ДнейБолезниУходаЗаДетьми = ТаблицаЗаработка[ИндексМесяца]["Год" + НомерГода + "ДниУхода"];
				
			Если Заработок <> 0 ИЛИ ДнейБолезниУходаЗаДетьми <> 0 Тогда
				ДанныеЗаполнены = Истина;
				Прервать;
			КонецЕсли; 
				
		КонецЦикла;
		
		Если ДанныеЗаполнены Тогда
			Прервать;
		КонецЕсли; 
				
	КонецЦикла;
	
	Если ДанныеЗаполнены Тогда
		
		ТекстВопроса = НСтр("ru='Перед заполнением введенные данные будут очищены.
			|Продолжить?'");
			
		ОписаниеОповещения = Новый ОписаниеОповещения("ПеречитатьДанныеУчетаЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	Иначе
		ПеречитатьДанныеУчетаЗавершение(КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура Пересчитать()
	
	ГодМесяцПриИзмененииНаСервере();
	УстановитьПодсказкуКРасчетуСреднегоЗаработка();
	ПодсчитатьИтог(ТаблицаЗаработка, ИтогГод1, ИтогГод2);
	Документы.БольничныйЛист.РассчитатьНачисления(Объект, ДополнительныеПараметрыРасчета());
	
КонецПроцедуры

&НаКлиенте
Процедура ПеречитатьДанныеУчетаЗавершение(Знач Результат, Знач Параметры = Неопределено) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьПоДаннымУчета();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуКПринятиюИзменений()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"НастройкиПользователя", "РежимПодробногоВводаСреднегоЗаработкаФСС", РежимПодробногоВводаСреднегоЗаработка);
	
	СохранитьДанныеРасчетаСреднего();
	
	АдресВХранилище = Документы.БольничныйЛист.АдресПараметровВХранилище(Объект, ДополнительныеПараметрыРасчета());
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервере
Функция ДополнительныеПараметрыРасчета()
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПодразделениеСотрудника",     ПодразделениеСотрудника);
	ДополнительныеПараметры.Вставить("ВидОплатыЗаСчетРаботодателя", ВидОплатыЗаСчетРаботодателя);
	ДополнительныеПараметры.Вставить("ВидОплатыПособия",            ВидОплатыПособия);
	ДополнительныеПараметры.Вставить("ВидНеоплачиваемогоВремени",   ВидНеоплачиваемогоВремени);
	ДополнительныеПараметры.Вставить("УникальныйИдентификатор",     ИдентификаторВладельца);
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

&НаСервере
Процедура СохранитьДанныеРасчетаСреднего()
	
	РасчетныеГоды = Новый Массив;
	РасчетныеГоды.Добавить(Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод);
	РасчетныеГоды.Добавить(Объект.ПериодРасчетаСреднегоЗаработкаВторойГод);
	
	НомерГода = 1;
	Объект.СреднийЗаработокФСС.Очистить();
	Объект.ОтработанноеВремяДляСреднегоФСС.Очистить();
	Для каждого Год Из РасчетныеГоды Цикл
		
		Для НомерМесяца = 1 По 12 Цикл
			
			ИндексМесяца = НомерМесяца - 1;
			
			Заработок = ТаблицаЗаработка[ИндексМесяца]["Год" + НомерГода + "Месяц"];
			ДнейБолезниУходаЗаДетьми = ТаблицаЗаработка[ИндексМесяца]["Год" + НомерГода + "ДниУхода"];
				
			Если Заработок <> 0 Тогда
				ЗаписьСреднего = Объект.СреднийЗаработокФСС.Добавить();
				ЗаписьСреднего.ФизическоеЛицо = ФизическоеЛицо;
				ЗаписьСреднего.Период         = Дата(Год, НомерМесяца, 1);
				ЗаписьСреднего.Сумма          = Заработок;
			КонецЕсли;
			
			Если ДнейБолезниУходаЗаДетьми <> 0 Тогда
				ЗаписьОВремени = Объект.ОтработанноеВремяДляСреднегоФСС.Добавить();
				ЗаписьОВремени.ФизическоеЛицо           = ФизическоеЛицо;
				ЗаписьОВремени.Период                   = Дата(Год, НомерМесяца, 1);
				ЗаписьОВремени.ДнейБолезниУходаЗаДетьми = ДнейБолезниУходаЗаДетьми;
			КонецЕсли;
			
		КонецЦикла;
		
		НомерГода = НомерГода + 1;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДаннымУчета()
	
	Для НомерГода = 1 По 2 Цикл
		
		Для НомерМесяца = 1 По 12 Цикл
			
			ИндексМесяца = НомерМесяца - 1;
			
			ТаблицаЗаработка[ИндексМесяца]["Год" + НомерГода + "Месяц"]    = 0;
			ТаблицаЗаработка[ИндексМесяца]["Год" + НомерГода + "ДниУхода"] = 0;
			
		КонецЦикла;
		
	КонецЦикла;
	
	РасчетныеГоды = Новый Массив;
	РасчетныеГоды.Добавить(Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод);
	РасчетныеГоды.Добавить(Объект.ПериодРасчетаСреднегоЗаработкаВторойГод);
	
	ДанныеОЗаработке = РасчетЗарплатыДляНебольшихОрганизаций.ДанныеОЗаработкеДляРасчетаСреднегоФСС(
		Сотрудник, Организация, ДатаНачалаСобытия, РасчетныеГоды);
		
	Для каждого СведенияОГоде Из ДанныеОЗаработке Цикл
			
		ИндексГода = РасчетныеГоды.Найти(СведенияОГоде.Ключ);
		Если ИндексГода <> Неопределено Тогда
			
			НомерГода = ИндексГода + 1;
			Для Каждого СведенияМесяца Из СведенияОГоде.Значение Цикл
				
				НомерМесяца  = СведенияМесяца.Ключ;
				ИндексМесяца = НомерМесяца - 1;
				
				Если СведенияМесяца.Значение.Сумма <> 0 Тогда
					ТаблицаЗаработка[ИндексМесяца]["Год" + НомерГода + "Месяц"] = СведенияМесяца.Значение.Сумма;
				КонецЕсли; 
					
				Если СведенияМесяца.Значение.ДнейБолезниУходаЗаДетьми <> 0 Тогда
					ТаблицаЗаработка[ИндексМесяца]["Год" + НомерГода + "ДниУхода"] = 
						СведенияМесяца.Значение.ДнейБолезниУходаЗаДетьми;
				КонецЕсли; 
					
			КонецЦикла;
			
		КонецЕсли; 
		
	КонецЦикла;
	
	ПараметрыРасчета = ПараметрыРасчетаСреднегоДневногоЗаработкаФСС();

	Объект.СреднийДневнойЗаработок = УчетПособийСоциальногоСтрахования.СреднийДневнойЗаработокФСС(ПараметрыРасчета);
	Объект.МинимальныйСреднедневнойЗаработок =
		УчетПособийСоциальногоСтрахования.МинимальныйСреднедневнойЗаработокФСС(ПараметрыРасчета);
	
	УстановитьПодсказкуКРасчетуСреднегоЗаработка();
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
		ЭтаФорма,
		"ГруппаПериод",
		"");
		
	СвернутьДанныеДляКраткойФормы(ЭтаФорма);
	
	Пересчитать();
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыРасчетаСреднегоДневногоЗаработкаФСС()
	
	ПараметрыРасчета = УчетПособийСоциальногоСтрахованияКлиентСервер.ПараметрыРасчетаСреднегоДневногоЗаработкаФСС();
	ПараметрыРасчета.ДатаНачалаСобытия = ДатаНачалаСобытия;
	ПараметрыРасчета.ПериодРасчетаСреднегоЗаработкаНачало =
		Дата(Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод, 1, 1) ;
	ПараметрыРасчета.ПериодРасчетаСреднегоЗаработкаОкончание =
		КонецДня(Дата(Объект.ПериодРасчетаСреднегоЗаработкаВторойГод, 12, 31));
	
	РасчетныеГоды = Новый Массив;
	РасчетныеГоды.Добавить(Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод);
	РасчетныеГоды.Добавить(Объект.ПериодРасчетаСреднегоЗаработкаВторойГод);

	ПараметрыРасчета.РасчетныеГоды = РасчетныеГоды;
	
	ПараметрыРасчета.НеполныйРасчетныйПериод =
		УчетПособийСоциальногоСтрахования.ПособиеЗаНеполныйРасчетныйПериод(ФизическоеЛицо, ДатаНачалаСобытия);
	
	ПараметрыРасчета.ДанныеНачислений = ДанныеОЗаработкеДляРасчетаСреднегоЗаработка();
	ПараметрыРасчета.ДанныеВремени = ДанныеОбОтработанномВремениДляРасчетаСреднегоЗаработка();
	ПараметрыРасчета.ДанныеСтрахователей =
		УчетПособийСоциальногоСтрахования.ПустаяТаблицаДанныеСтрахователейСреднийЗаработокФСС();
	ПараметрыРасчета.ИспользоватьДниБолезниУходаЗаДетьми =
		ПричинаНетрудоспособности = Перечисления.ПричиныНетрудоспособности.ПоБеременностиИРодам;
	ПараметрыРасчета.ПрименятьПредельнуюВеличину =
		ПричинаНетрудоспособности <> Перечисления.ПричиныНетрудоспособности.ТравмаНаПроизводстве
		И ПричинаНетрудоспособности <> Перечисления.ПричиныНетрудоспособности.Профзаболевание; 
	ПараметрыРасчета.ПорядокРасчета =
		УчетПособийСоциальногоСтрахованияКлиентСервер.ПорядокРасчетаСреднегоЗаработкаФСС(ДатаНачалаСобытия);
	ПараметрыРасчета.РайонныйКоэффициентРФ = РайонныйКоэффициентРФНаНачалоСобытия;
	ПараметрыРасчета.Сотрудник = Сотрудник;
		
	Возврат ПараметрыРасчета;
	
КонецФункции

&НаСервере
Функция ДанныеОЗаработкеДляРасчетаСреднегоЗаработка()
	
	ДанныеОЗаработкеДляРасчетаСреднегоЗаработка =
		УчетПособийСоциальногоСтрахования.ПустаяТаблицаНачисленийСреднийЗаработокФСС();
	
	РасчетныеГоды = Новый Массив;
	РасчетныеГоды.Добавить(Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод);
	РасчетныеГоды.Добавить(Объект.ПериодРасчетаСреднегоЗаработкаВторойГод);
	
	ДнейБолезниУходаЗаДетьми = 0;
	
	НомерГода = 1;
	Для каждого Год Из РасчетныеГоды Цикл
		
		Для НомерМесяца = 1 По 12 Цикл
			
			ИндексМесяца = НомерМесяца - 1;
			Период = Дата(Год, НомерМесяца, 1);
			
			СтрокаДанныхОЗаработке = ДанныеОЗаработкеДляРасчетаСреднегоЗаработка.Добавить();
			СтрокаДанныхОЗаработке.ФизическоеЛицо = ФизическоеЛицо;
			СтрокаДанныхОЗаработке.ПорядокРасчета = Перечисления.ПорядокРасчетаСреднегоЗаработкаФСС.Постановление2011;
			СтрокаДанныхОЗаработке.Период = Период;
			
			Сумма = ТаблицаЗаработка[ИндексМесяца]["Год" + НомерГода + "Месяц"];
			СтрокаДанныхОЗаработке.Сумма = Сумма;
			
		КонецЦикла;
		
		НомерГода = НомерГода + 1;
		
	КонецЦикла;
	
	Возврат ДанныеОЗаработкеДляРасчетаСреднегоЗаработка;
	
КонецФункции

&НаСервере
Функция ДанныеОбОтработанномВремениДляРасчетаСреднегоЗаработка()
	
	ДанныеОбОтработанномВремениДляРасчетаСреднегоЗаработка =
		УчетПособийСоциальногоСтрахования.ПустаяТаблицаОтработанноеВремяСреднийЗаработокФСС();
	
	РасчетныеГоды = Новый Массив;
	РасчетныеГоды.Добавить(Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод);
	РасчетныеГоды.Добавить(Объект.ПериодРасчетаСреднегоЗаработкаВторойГод);
	
	НомерГода = 1;
	Для каждого Год Из РасчетныеГоды Цикл
		
		Для НомерМесяца = 1 По 12 Цикл
			
			ИндексМесяца = НомерМесяца - 1;
			Период = Дата(Год, НомерМесяца, 1);
			
			СтрокаДанныхОбОтработанномВремени = ДанныеОбОтработанномВремениДляРасчетаСреднегоЗаработка.Добавить();
			СтрокаДанныхОбОтработанномВремени.ФизическоеЛицо = ФизическоеЛицо;
			СтрокаДанныхОбОтработанномВремени.Период = Период;
			
			ДнейБолезниУходаЗаДетьми = ТаблицаЗаработка[ИндексМесяца]["Год" + НомерГода + "ДниУхода"];
			СтрокаДанныхОбОтработанномВремени.ДнейБолезниУходаЗаДетьми = ДнейБолезниУходаЗаДетьми;
			
		КонецЦикла;
		
		НомерГода = НомерГода + 1;
		
	КонецЦикла;
	
	Возврат ДанныеОбОтработанномВремениДляРасчетаСреднегоЗаработка;
	
КонецФункции

&НаСервере
Процедура УстановитьПодсказкуКРасчетуСреднегоЗаработка()
	
	РасчетныеГоды = Новый Массив;
	РасчетныеГоды.Добавить(Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод);
	РасчетныеГоды.Добавить(Объект.ПериодРасчетаСреднегоЗаработкаВторойГод);
	
	Итого     = ТаблицаЗаработка.Итог("Год1Месяц") + ТаблицаЗаработка.Итог("Год2Месяц");
	ИтогоДней = ТаблицаЗаработка.Итог("Год1ДниУхода") + ТаблицаЗаработка.Итог("Год2ДниУхода");
	
	ПараметрыРасчета = ПараметрыРасчетаСреднегоДневногоЗаработкаФСС();
	ДанныеРасчетаСреднего =
		УчетПособийСоциальногоСтрахованияКлиентСервер.ДанныеРасчетаСреднегоЗаработкаФСС(ПараметрыРасчета);
	КалендарныхДней =
		УчетПособийСоциальногоСтрахованияКлиентСервер.УчитываемыхДнейВКалендарныхГодахФСС(ПараметрыРасчета,
																							ДанныеРасчетаСреднего);
	
	Если Итого <> 0 Тогда
		
		ТекстПодсказки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Средний заработок: %1 / %2 = %3'"),
			Итого,
			КалендарныхДней,
			Формат(?(КалендарныхДней = 0, 0, Итого/ КалендарныхДней), "ЧДЦ=2"));
			
		ТекстПодсказки = ТекстПодсказки + Символы.ПС + Символы.ПС;
		
		МасивСтрок = Новый Массив;
		МасивСтрок.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Средний заработок: %1 / %2 = '"),
			Итого,
			КалендарныхДней));
		МасивСтрок.Добавить(
			Новый ФорматированнаяСтрока(Формат(?(КалендарныхДней = 0, 0, Итого/ КалендарныхДней), "ЧДЦ=2; ЧН=0,00"),
			Новый Шрифт(,, Истина)));
			
		ТекстРасшифровкиСреднедневной = Новый ФорматированнаяСтрока(МасивСтрок);
			
	Иначе
		
		МасивСтрок = Новый Массив;
		МасивСтрок.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Средний заработок: %1 / %2 = '"),
			Итого,
			КалендарныхДней));
		МасивСтрок.Добавить(
			Новый ФорматированнаяСтрока(Формат(?(КалендарныхДней = 0, 0, Итого/ КалендарныхДней), "ЧДЦ=2; ЧН=0,00"),
			Новый Шрифт(,, Истина)));
			
		ТекстРасшифровкиСреднедневной = Новый ФорматированнаяСтрока(МасивСтрок);
	КонецЕсли;
	
	МРОТ = ЗарплатаКадры.МинимальныйРазмерОплатыТрудаРФ(ДатаНачалаСобытия);
	
	ТекстРасшифровки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='МРОТ на %1: %2'"),
			Формат(ДатаНачалаСобытия, "ДЛФ=D"),
			Формат(МРОТ, "ЧДЦ=2"));
	
	Если РайонныйКоэффициентРФНаНачалоСобытия > 1 Тогда
		
		ТекстРасшифровки = ТекстРасшифровки +
			Символы.ПС +
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Районный коэффициент: %1'"),
						Формат(РайонныйКоэффициентРФНаНачалоСобытия, "ЧДЦ=2"));
		
		МРОТ = МРОТ * РайонныйКоэффициентРФНаНачалоСобытия;
		
	КонецЕсли;
	
	Если КалендарныхДней = 0 Тогда
		СреднийМРОТ = 0;
	Иначе
		СреднийМРОТ = МРОТ * 24 / КалендарныхДней;
	КонецЕсли;
	
	ТекстРасшифровки = ТекстРасшифровки +
		Символы.ПС +
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Минимальный средний заработок исходя из МРОТ: %1'"),
					Формат(СреднийМРОТ, "ЧДЦ=2"));
		
	Элементы.СреднийЗаработокМРОТДекорация.Заголовок = ТекстРасшифровки;
	Элементы.СреднийЗаработокРасшифровкиСреднедневной.Заголовок = ТекстРасшифровкиСреднедневной;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСреднийЗаработокФСС()
	
	ДопустимРежимКраткогоВвода = Истина;
	Для каждого СтрокаСреднегоЗаработкаФСС  Из Объект.СреднийЗаработокФСС Цикл
		
		Год = Год(СтрокаСреднегоЗаработкаФСС.Период);
		Если Год = Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод Тогда
			НомерГода = 1;
		ИначеЕсли Год = Объект.ПериодРасчетаСреднегоЗаработкаВторойГод Тогда
			НомерГода = 2;
		Иначе
			НомерГода = Неопределено;
		КонецЕсли;
			
		Если НомерГода <> Неопределено Тогда
			
			НомерМесяца  = Месяц(СтрокаСреднегоЗаработкаФСС.Период);
			ИндексМесяца = НомерМесяца - 1;
			
			Если НомерМесяца <> 1 И СтрокаСреднегоЗаработкаФСС.Сумма <> 0 Тогда
				ДопустимРежимКраткогоВвода = Ложь;
			КонецЕсли;
			
			ТаблицаЗаработка[ИндексМесяца]["Год" + НомерГода + "Месяц"] = СтрокаСреднегоЗаработкаФСС.Сумма;
			
		КонецЕсли; 
		
	КонецЦикла;
	
	Для каждого СтрокаОтработанногоВремени Из Объект.ОтработанноеВремяДляСреднегоФСС Цикл
		
		Год = Год(СтрокаОтработанногоВремени.Период);
		Если Год = Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод Тогда
			НомерГода = 1;
		ИначеЕсли Год = Объект.ПериодРасчетаСреднегоЗаработкаВторойГод Тогда
			НомерГода = 2;
		Иначе
			НомерГода = Неопределено;
		КонецЕсли;
			
		Если НомерГода <> Неопределено Тогда
			
			НомерМесяца = Месяц(СтрокаОтработанногоВремени.Период);
			ИндексМесяца = НомерМесяца - 1;
			
			Если НомерМесяца <> 1 И СтрокаОтработанногоВремени.ДнейБолезниУходаЗаДетьми <> 0 Тогда
				ДопустимРежимКраткогоВвода = Ложь;
			КонецЕсли;
			
			ТаблицаЗаработка[ИндексМесяца]["Год" + НомерГода + "ДниУхода"] =
				СтрокаОтработанногоВремени.ДнейБолезниУходаЗаДетьми;
			
		КонецЕсли; 
		
	КонецЦикла;
	
	Если Не ДопустимРежимКраткогоВвода Тогда
		РежимПодробногоВводаСреднегоЗаработка = Истина;
		РежимПодробногоВводаСреднегоЗаработкаЧисло = 1;
	КонецЕсли;
	
	ПодсчитатьИтог(ТаблицаЗаработка, ИтогГод1, ИтогГод2);
	УстановитьОтображениеКраткойПодробнойФормыВвода(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРасчетногоГода(ИндексГода)
	
	МаксимальноВозможныйГод = Год(ДатаНачалаСобытия) - 1;
	Если ИндексГода = 0 Тогда
		
		Если Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод >= Объект.ПериодРасчетаСреднегоЗаработкаВторойГод Тогда
			
			Объект.ПериодРасчетаСреднегоЗаработкаВторойГод =
				Мин(МаксимальноВозможныйГод, Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод + 1);
			
			Если Объект.ПериодРасчетаСреднегоЗаработкаВторойГод = МаксимальноВозможныйГод Тогда
				Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод = Объект.ПериодРасчетаСреднегоЗаработкаВторойГод - 1;
			КонецЕсли;
			
		КонецЕсли; 
		
	Иначе
		
		Если Объект.ПериодРасчетаСреднегоЗаработкаВторойГод > МаксимальноВозможныйГод Тогда
			Объект.ПериодРасчетаСреднегоЗаработкаВторойГод = МаксимальноВозможныйГод;
		КонецЕсли;
		
		Если Объект.ПериодРасчетаСреднегоЗаработкаВторойГод <= Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод Тогда
			
			Если Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод = 1 Тогда
				Объект.ПериодРасчетаСреднегоЗаработкаВторойГод = 2;
			Иначе
				Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод = Объект.ПериодРасчетаСреднегоЗаработкаВторойГод - 1;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	НастроитьМаксимальноеКоличествоДнейВФеврале(ЭтотОбъект);
	
	ОбновитьЗаголовкиТаблицы(ЭтотОбъект);
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
		ЭтаФорма,
		"ГруппаПериод",
		НСтр("ru='После изменения расчетного периода, необходимо перезаполнить данные'"));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗаголовкиТаблицы(Форма)
	
	Форма.Элементы.ТаблицаЗаработкаГруппа1.Заголовок = СтрШаблон(НСтр("ru='%1 год'"),
		Строка(Формат(Форма.Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод, "ЧГ=")));
	Форма.Элементы.ТаблицаЗаработкаГруппа1.Заголовок = СтрШаблон(НСтр("ru='%1 год'"),
		Строка(Формат(Форма.Объект.ПериодРасчетаСреднегоЗаработкаВторойГод, "ЧГ=")));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ТаблицаЗаработкаГруппа1",
		"Заголовок",
		СтрШаблон(НСтр("ru='%1 год'"), Строка(Формат(Форма.Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод, "ЧГ="))));
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ТаблицаЗаработкаГруппа2",
		"Заголовок",
		СтрШаблон(НСтр("ru='%1 год'"), Строка(Формат(Форма.Объект.ПериодРасчетаСреднегоЗаработкаВторойГод, "ЧГ="))));
		
	Если Форма.ПричинаНетрудоспособности <>
			ПредопределенноеЗначение("Перечисление.ПричиныНетрудоспособности.ПоБеременностиИРодам") Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ТаблицаЗаработкаГод1Месяц",
			"Заголовок",
			СтрШаблон(НСтр("ru='Заработок (%1)'"),
				Строка(Формат(Форма.Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод, "ЧГ="))));
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ТаблицаЗаработкаГод2Месяц",
			"Заголовок",
			СтрШаблон(НСтр("ru='Заработок (%1)'"),
				Строка(Формат(Форма.Объект.ПериодРасчетаСреднегоЗаработкаВторойГод, "ЧГ="))));
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	Заголовок = СтрШаблон(НСтр("ru='Расчет больничного (%1)%2'"),
							Сотрудник,
							?(ТолькоПросмотр, НСтр("ru=' (только просмотр)'"), ""));
	
КонецПроцедуры

&НаСервере
Процедура ГодМесяцПриИзмененииНаСервере()
	
	ПараметрыРасчета = ПараметрыРасчетаСреднегоДневногоЗаработкаФСС();
	Объект.СреднийДневнойЗаработок = УчетПособийСоциальногоСтрахования.СреднийДневнойЗаработокФСС(ПараметрыРасчета);
	Объект.МинимальныйСреднедневнойЗаработок =
		УчетПособийСоциальногоСтрахования.МинимальныйСреднедневнойЗаработокФСС(ПараметрыРасчета);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьМаксимальноеКоличествоДнейВФеврале(Форма)
	
	КоличествоДней =
		ЗарплатаКадрыКлиентСервер.КоличествоДнейМесяца(Дата(Форма.Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод,2,1));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"Год1ДниУхода2",
		"МаксимальноеЗначение",
		КоличествоДней);
	
	ТекущееКоличество = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, "Год1ДниУхода2");
	Если ТекущееКоличество > КоличествоДней Тогда
		Форма.ТаблицаЗаработка[1].Год1ДниУхода = КоличествоДней;
	КонецЕсли;
	
	КоличествоДней =
		ЗарплатаКадрыКлиентСервер.КоличествоДнейМесяца(Дата(Форма.Объект.ПериодРасчетаСреднегоЗаработкаВторойГод,2,1));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"Год2ДниУхода2",
		"МаксимальноеЗначение",
		КоличествоДней);
	
	ТекущееКоличество = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, "Год2ДниУхода2");
	Если ТекущееКоличество > КоличествоДней Тогда
		Форма.ТаблицаЗаработка[1].Год2ДниУхода = КоличествоДней;
	КонецЕсли;
	
	УстановитьКоличествоДнейПервыхМесяцев(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СвернутьДанныеДляКраткойФормы(Форма)
	
	Если Форма.РежимПодробногоВводаСреднегоЗаработка Тогда
		Возврат;
	КонецЕсли; 
	
	Для НомерГода = 1 По 2 Цикл
		
		СуммаПоГоду = 0;
		СуммаДнейПоГоду = 0;
		Для НомерМесяца = 1 По 12 Цикл
			
			ИндексМесяца = НомерМесяца - 1;
			
			СуммаПоГоду = СуммаПоГоду + Форма.ТаблицаЗаработка[ИндексМесяца]["Год" + НомерГода + "Месяц"];
			Форма.ТаблицаЗаработка[ИндексМесяца]["Год" + НомерГода + "Месяц"] = 0;
			
			СуммаДнейПоГоду = СуммаДнейПоГоду + Форма.ТаблицаЗаработка[ИндексМесяца]["Год" + НомерГода + "ДниУхода"];
			Форма.ТаблицаЗаработка[ИндексМесяца]["Год" + НомерГода + "ДниУхода"] = 0;
			
		КонецЦикла;
		
		Форма.ТаблицаЗаработка[0]["Год" + НомерГода + "Месяц"]    = СуммаПоГоду;
		Форма.ТаблицаЗаработка[0]["Год" + НомерГода + "ДниУхода"] = СуммаДнейПоГоду;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеКраткойПодробнойФормыВвода(Форма)
	
	Форма.Элементы.ДанныеОЗаработкеГруппаГод.Видимость     = НЕ Форма.РежимПодробногоВводаСреднегоЗаработка;
	Форма.Элементы.ДанныеОЗаработкеГруппаТаблица.Видимость = Форма.РежимПодробногоВводаСреднегоЗаработка;
	
	УстановитьКоличествоДнейПервыхМесяцев(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьКоличествоДнейПервыхМесяцев(Форма)
	
	Если Форма.РежимПодробногоВводаСреднегоЗаработка Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"Год1ДниУхода1",
			"МаксимальноеЗначение",
			31);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"Год2ДниУхода1",
			"МаксимальноеЗначение",
			31);
		
	Иначе
		
		КоличествоДней = ДеньГода(Дата(Форма.Объект.ПериодРасчетаСреднегоЗаработкаПервыйГод,12,31));
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"Год1ДниУхода1",
			"МаксимальноеЗначение",
			КоличествоДней);
		
		КоличествоДней = ДеньГода(Дата(Форма.Объект.ПериодРасчетаСреднегоЗаработкаВторойГод,12,31));
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"Год2ДниУхода1",
			"МаксимальноеЗначение",
			КоличествоДней);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьТаблицу()
	
	Месяц = НачалоГода(ТекущаяДата());
	
	Для СчетчикМесяцев = 0 По 11 Цикл
		
		НоваяСтрока = ТаблицаЗаработка.Добавить();
		НоваяСтрока.Месяц  = Формат(Месяц, "ДФ='ММММ'");
		
		Месяц = ДобавитьМесяц(НачалоМесяца(Месяц), 1);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПодсчитатьИтог(Знач ТаблицаЗаработка, ИтогГод1, ИтогГод2)
	
	ИтогГод1 = ТаблицаЗаработка.Итог("Год1Месяц");
	ИтогГод2 = ТаблицаЗаработка.Итог("Год2Месяц");
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросСохранитьИзменения()
	
	ТекстВопроса = НСтр("ru='Данные были изменены. Сохранить изменения?'");
	Оповещение = Новый ОписаниеОповещения("ВопросСохранитьИзмененияЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросСохранитьИзмененияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПодготовитьФормуКПринятиюИзменений();
		Закрыть(АдресВХранилище);
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти