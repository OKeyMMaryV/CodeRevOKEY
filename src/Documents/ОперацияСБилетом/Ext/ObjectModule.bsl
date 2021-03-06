
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыБилета = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Билет, "Организация, ПодразделениеОрганизации");
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыБилета);
	
	ДополнительныеСвойства.Вставить("ЗаполнитьСчетаУчетаПередЗаписью", Истина);
	СчетаУчетаВДокументах.ЗаполнитьПередЗаписью(ЭтотОбъект, РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив;
	Ошибки = Неопределено;
	
	РеквизитыБилета = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Билет, "Организация, НДСНеВыделять");
	
	Если НЕ ЗначениеЗаполнено(РеквизитыБилета.Организация) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
			Ошибки, 
			"Объект.Билет",
			Нстр("ru='Не указана организация в билете'"),
			"Билет");
	КонецЕсли;
		
	Если РеквизитыБилета.НДСНеВыделять Тогда	
		МассивНепроверяемыхРеквизитов.Добавить("СтавкаНДС");
	КонецЕсли;
	
	Если ВидОперации <> Перечисления.ВидыОперацийСБилетами.ЗаменаВозврат Тогда
		МассивНепроверяемыхРеквизитов.Добавить("БилетЗамена");
	КонецЕсли; 	
		
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
		
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ОперацияСБилетом.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	
	// Таблица зачета авансов.
	// Способ зачета всегда "Автоматически".
	ТаблицаВзаиморасчетов = УчетВзаиморасчетов.ПодготовитьТаблицуВзаиморасчетовЗачетАвансов(
		ПараметрыПроведения.ЗачетАвансовТаблица,
		Неопределено, 
		ПараметрыПроведения.ЗачетАвансовРеквизиты, 
		Отказ);

	// Таблица возврата.
	// Способ зачета всегда "Автоматически".
	ТаблицаВзаиморасчетовВозврат = УчетВзаиморасчетов.ПодготовитьТаблицуВзаиморасчетовЗачетАвансов(
		ПараметрыПроведения.ВозвратТаблица, 
		Неопределено, 
		ПараметрыПроведения.ВозвратРеквизиты, 
		Отказ);
		
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	// Зачет аванса
	УчетВзаиморасчетов.СформироватьДвиженияЗачетАвансов(ТаблицаВзаиморасчетов,
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Движения, Отказ);
		
	// Отражение возврата во взаиморасчетах
	УчетВзаиморасчетов.СформироватьДвиженияЗачетАвансов(ТаблицаВзаиморасчетовВозврат,
		ПараметрыПроведения.ВозвратРеквизиты, Движения, Отказ);
		
	// Восстановление аванса при возврате	
	Документы.ОперацияСБилетом.СформироватьДвиженияВосстановлениеАванса(
		ТаблицаВзаиморасчетовВозврат, ПараметрыПроведения.ВозвратРеквизиты, Движения, Отказ);
		
	// Хозрасчетный
	Документы.ОперацияСБилетом.СформироватьДвиженияХозрасчетный(ПараметрыПроведения.Реквизиты, Движения, Отказ); 
	
	// УСН
	
	// Данные для отражения в налоговом учете УСН
	СтруктураДопПараметровУСН = Новый Структура;
	
	Если ВидОперации = Перечисления.ВидыОперацийСБилетами.Возврат ИЛИ
		 ВидОперации = Перечисления.ВидыОперацийСБилетами.ЗаменаВозврат Тогда
		 		
		СтруктураДопПараметровУСН.Вставить("ТаблицаБилетов", ПараметрыПроведения.ТаблицаБилетов);
		
	Иначе	 
				
		СуммаСторноРасхода = 0;
		УчетУСН.ПоступлениеРасходовУСН(ПараметрыПроведения.ПоступлениеРасходовУСНТаблицаРасходов, 
			ПараметрыПроведения.ПоступлениеРасходовУСНРеквизиты, СуммаСторноРасхода, Движения, Отказ);
		
		Если НЕ Отказ И Движения.РасходыПриУСН.Количество() > 0 Тогда
			Движения.РасходыПриУСН.Записать(Истина);
			Движения.РасходыПриУСН.Записывать = Ложь;
		КонецЕсли; 
		
		СтруктураДопПараметровУСН.Вставить("ТаблицаРасчетов", ТаблицаВзаиморасчетов);
				
	КонецЕсли;	
	
	НалоговыйУчетУСН.СформироватьДвиженияУСН(ЭтотОбъект, СтруктураДопПараметровУСН);
	
	// Отложенные расчеты с контрагентами.
	УчетВзаиморасчетовОтложенноеПроведение.ЗарегистрироватьОтложенныеРасчетыСКонтрагентами(
		ЭтотОбъект, Отказ, ПараметрыПроведения.РасчетыСКонтрагентамиОтложенноеПроведение);
		
	// Регистрация в последовательности
	РаботаСПоследовательностями.ЗарегистрироватьОтложенныеРасчетыВПоследовательности(
		ЭтотОбъект, Отказ, ПараметрыПроведения.РасчетыСКонтрагентамиОтложенноеПроведение);
		
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
		
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

	РаботаСПоследовательностями.ОтменитьРегистрациюВПоследовательности(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли